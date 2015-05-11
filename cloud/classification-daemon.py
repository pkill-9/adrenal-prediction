#!  /usr/bin/env python
#
# Daemon that regularly polls the spool directory on a VM to see if any
# new samples have been uploaded for classification, and runs the octave
# classification script on them. This program is started automatically
# when a VM is launched.
#
# Inspired by Sander Marechal's example at 
# http://www.jejik.com/articles/2007/02/a_simple_unix_linux_daemon_in_python/

import sys, os, time, atexit
from signal import SIGTERM, SIGKILL

class Daemon:

# *********************************************************

    def __init__ (self, pidfile, stdin = "/dev/null", stdout = "/dev/null",
            stderr = "/dev/null"):
        self.stdin = stdin
        self.stdout = stdout
        self.stderr = stderr
        self.pidfile = pidfile

# *********************************************************

    def daemonise (self):
        # convert to a daemon by decoupling from the execution environment
        # of the parent process.
        try:
            pid = os.fork ()

            if pid > 0:
                sys.exit (0)

        except OSError:
            sys.stderr.write ("Failed to daemonise.\n")
            sys.exit (1)

        # change from the parent environment to the daemon env.
        os.chdir ("/home/ubuntu/adrenal-prediction")
        os.setsid ()
        os.umask (0)

        # do second fork to prevent the daemon from ever acquiring a
        # controlling TTY; since the first child is a session leader due
        # to the setsid call.
        try:
            pid = os.fork ()

            if pid > 0:
                sys.exit (0)

        except OSError:
            sys.stderr.write ("Failed to daemonise at second fork\n")
            sys.exit (0)

        self.redirect_file_descriptors ()
        self.write_pidfile ()

# *********************************************************

    def redirect_file_descriptors (self):
        # Redirects the standard stdin, stdout and stderr file
        # descriptors, in order that the daemon is no longer reading and
        # writing on a TTY.
        sys.stdout.flush ()
        sys.stderr.flush ()

        # open the new file descriptors.
        si = file (self.stdin, "r")
        so = file (self.stdout, "a+")
        se = file (self.stderr, "a+")

        # replace the standard descriptors with the new ones, closing the
        # old file handles first.
        os.dup2 (si.fileno (), sys.stdin.fileno ())
        os.dup2 (so.fileno (), sys.stdout.fileno ())
        os.dup2 (se.fileno (), sys.stderr.fileno ())

# *********************************************************

    def write_pidfile (self):
        # create a file on the path specified by pidfile, and store our
        # pid in it. Also adds a hook so that when the daemon exits, it
        # will remove the pidfile first.
        atexit.register (self.delpid)
        pid = str (os.getpid ())
        file (self.pidfile, "w+").write ("%s\n" % pid)

# *********************************************************

    def delpid (self):
        os.remove (self.pidfile)

# *********************************************************

    def start (self):
        # check if there is already a pidfile. That could indicate that a
        # daemon is already running.
        if os.path.exists (self.pidfile):
            sys.stderr.write ("pidfile already exists.\n")
            sys.exit (1)

        # start the daemon.
        self.daemonise ()
        self.run ()

# *********************************************************

    def stop (self):
        # stop the daemon by getting the process id from the specified
        # pidfile, then sending the SIGTERM signal.

        try:
            pf = file (self.pidfile, "r")
            pid = int (pf.read ().strip ())
            pf.close ()

        except IOError:
            pid = None

        if not pid:
            sys.stderr.write ("Could not read pidfile\n")
            return

        # terminate the daemon process with a signal.
        os.kill (pid, SIGTERM)
        time.sleep (1)

        if not os.path.exists (self.pidfile):
            return

        # if the pid file hasn't been removed, then the daemon has not
        # stopped on SIGTERM. Time for extreme prejudice.
        os.kill (pid, SIGKILL)

# *********************************************************

    def restart (self):
        self.stop ()
        self.start ()

# *********************************************************

    def run (self):
        # Poll the directory ./spool looking for any new input files.
        # When we find one, we will run the classification code on it,
        # storing the output in the same directory.
        running_jobs = {}

        while True:
            # get a list of all the input files in the directory. Any
            # input samples that are not in the running jobs list must be
            # new samples, so we will process them.
            for sample in os.listdir ("/tmp/input"):
                if sample not in running_jobs:
                    # start the job and add to running list
                    self.process_sample (sample)
                    running_jobs [sample] = sample

            # now prune the running jobs list of any jobs that have 
            # finished, otherwise we would have a massive memory bomb when
            # the daemon is left running for a long period of time
            for name in os.listdir ("/tmp/output"):
                if name in running_jobs:
                    # remove the job from the dictionary and delete the
                    # input file. Note that the octave program may still
                    # be reading the input file, but it is still safe for
                    # us to rm it, since the file is only completely
                    # removed once all open handles are closed.
                    del running_jobs [output]
                    os.remove ("/tmp/input/" + name)

            # wait a while before we poll the input dir for more samples.
            time.sleep (10)

# *********************************************************

    def process_sample (self, sample):
        # fork off a new process to classify a given sample.
        pid = os.fork ()

        # the parent process will return after the fork.
        if pid > 0:
            return

        # child process calls os.exec, which replaces the current process
        # image with the specified command. This is why the fork is 
        # needed; without it we would have clobbered the daemon's process
        # image.
        env = {"input_dir": "/tmp/input", "output_dir": "/tmp/output", 
                "base_name": sample}
        os.execle ("cloud-job.sh", env)


# *********************************************************


if __name__ == "__main__":
    daemon = Daemon ("/tmp/classification-daemon.pid", 
            stdout = "/tmp/classification-stdout",
            stder = "/tmp/classification-stderr")

    if len (sys.argv) == 2:
        if sys.argv [1] == "start":
            daemon.start ()
        elif sys.argv [1] == "stop":
            daemon.stop ()
        elif sys.argv [1] == "restart":
            daemon.restart ()
        else:
            print "Unknown Command."

    sys.exit (0)

# vim: ts=4 sw=4 et

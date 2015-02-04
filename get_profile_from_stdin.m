% Reads a single set of steroid levels from stdin, in key value form. These
% levels are then stored in a struct with two arrays, one array of steroid
% names, and a second array of the numeric levels of the corresponding 
% steroid.

function steroid_profile = get_profile_from_stdin ()
    steroid_profile.steroids = [];
    steroid_profile.levels = [];
    steroid_profile.processed = [];

    while (! feof (stdin))
        [steroid, level, count] = scanf ("%s %d\n", "C");

        % NaN levels in the input are not treated as a number by scanf,
        % instead it only returns a single result (the steroid string),
        % and then treats NaN as a string; the next steroid name.
        %
        % So. If scanf has only read the steroid name, we shall assume
        % that the level should be NaN.
        if (count != 2)
            level = nan;
        endif

        % If the previous steroid's level was NaN, scanf will return the
        % NaN from the input as the next steroid name. We will ignore it,
        % and go on to the next steroid.
        if (strcmp (steroid, "NaN"))
            continue;
        endif

        steroid_profile.steroids = [steroid_profile.steroids; steroid];
        steroid_profile.levels = [steroid_profile.levels; level];
        steroid_profile.processed = [steroid_profile.processed; false];

        printf ("debug: steroid: %s, level: %d\n", steroid, level);
    end
end 


% vim: ts=4 sw=4 et

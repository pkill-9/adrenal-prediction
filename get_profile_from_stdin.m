% Reads a single set of steroid levels from stdin, in key=value form. These
% levels are then stored in a struct with two arrays, one array of steroid
% names, and a second array of the numeric levels of the corresponding 
% steroid.

function steroid_profile = get_profile_from_stdin ()
    steroid_profile.steroids = [];
    steroid_profile.levels = [];
    steroid_profile.processed = [];

    while [steroid, level] = scanf ("%s = %d")
        steroid_profile.steroids = [steroid_profile.steroids; steroid];
        steroid_profile.levels = [steroid_profile.levels; level];
        steroid_profile.processed = [steroid_profile.processed; false];
    end
end 


% vim: ts=4 sw=4 et

% Takes a struct containing two lists of steroid names and values
% respectively, and returns a vector containing 32 values for each steroid.
% If a steroid is not included in the input profile, the corresponding cell
% in the vector will be set to -1 and a warning message will be printed on
% stderr.

function vector = get_profile_vector (steroid_profile)
    vector = zeros (1, 32);

    vector (1) = get_level_from_profile (steroid_profile, "an");
    vector (2) = get_level_from_profile (steroid_profile, "et");
    vector (3) = get_level_from_profile (steroid_profile, "dhea");
    vector (4) = get_level_from_profile (steroid_profile, "x16a_dhea");
    vector (5) = get_level_from_profile (steroid_profile, "x5_pt");
    vector (6) = get_level_from_profile (steroid_profile, "all_5pd");
    vector (7) = get_level_from_profile (steroid_profile, "tha");
    vector (8) = get_level_from_profile (steroid_profile, "x5a_tha");
    vector (9) = get_level_from_profile (steroid_profile, "thb");
    vector (10) = get_level_from_profile (steroid_profile, "x5a_thb");
    vector (11) = get_level_from_profile (steroid_profile, "x3a5b_thaldo");
    vector (12) = get_level_from_profile (steroid_profile, "thdoc");
    vector (13) = get_level_from_profile (steroid_profile, "x5a_thdoc");
    vector (14) = get_level_from_profile (steroid_profile, "pd");
    vector (15) = get_level_from_profile (steroid_profile, "x3a5a_17hp");
    vector (16) = get_level_from_profile (steroid_profile, "x17_hp");
    vector (17) = get_level_from_profile (steroid_profile, "pt");
    vector (18) = get_level_from_profile (steroid_profile, "pt_one");
    vector (19) = get_level_from_profile (steroid_profile, "ths");
    vector (20) = get_level_from_profile (steroid_profile, "f");
    vector (21) = get_level_from_profile (steroid_profile, "x6b_oh_cortisol");
    vector (22) = get_level_from_profile (steroid_profile, "thf");
    vector (23) = get_level_from_profile (steroid_profile, "x5a_thf");
    vector (24) = get_level_from_profile (steroid_profile, "a_cortol");
    vector (25) = get_level_from_profile (steroid_profile, "b_cortol");
    vector (26) = get_level_from_profile (steroid_profile, "x11b_oh_andro");
    vector (27) = get_level_from_profile (steroid_profile, "x11b_oh_etio");
    vector (28) = get_level_from_profile (steroid_profile, "e");
    vector (29) = get_level_from_profile (steroid_profile, "the");
    vector (30) = get_level_from_profile (steroid_profile, "a_cortolone");
    vector (31) = get_level_from_profile (steroid_profile, "b_cortolone");
    vector (32) = get_level_from_profile (steroid_profile, "x11_oxo_etio");

    check_missed_steroids (steroid_profile);
end

function level = get_level_from_profile (steroid_profile, steroid)
    index = 0;
    found = false;

    for (s = steroid_profile.steroids)
        if (strcmp (steroid, s))
            found = true;
            break;
        endif

        index += 1;
    endfor

    if (found == false)
        fprintf (stderr, "Warning: Profile missing level for %s", steroid);
        return (level = -1);
    endif

    level = steroid_profile.levels (index);
    steroid_profile.processed (index) = true;
end

% Checks for any entries in the profile that were not touched when the
% profile was converted to a vector.
function check_missed_steroids (steroid_profile)
    for (n = 1:size (steroid_profile.processed))
        if (!steroid_profile.processed (n))
            fprintf (stderr, "Warning: Unknown steroid \"%s\" in profile\n", \
              steroid_profile.steroids (n));
        endif
    endfor
end

% vim: ts=4 sw=4 et

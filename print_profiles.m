% Function to print out the steroid levels given an array of profile
% structures.

function print_profiles (profiles)
    printf ("%d patients.\n", length (profiles));

    for profile_index = 1 : length (profiles)
        file_handle = checked_fopen (profiles (profile_index).index);
        print_profile (file_handle, profiles (profile_index));
        fclose (file_handle);
    endfor
end

% Function to open a specified file for writing, and check fopen's
% return value to catch any errors.
function fid = checked_fopen (filename)
    [fid, message] = fopen (filename, "wt");

    if (fid == -1)
        error ("Could not open %s: %s\n", filename, message);
    endif
endfunction

function print_profile (fid, p)
    % Don't get under the illusion that I meticulously alligned all of
    % these columns; I used visual block select in Vim to yank and paste
    % and it automagically came out like this :)
    print_level_if_available (fid, "an"             , p.steroid_profile.an);
    print_level_if_available (fid, "et"             , p.steroid_profile.et);
    print_level_if_available (fid, "dhea"           , p.steroid_profile.dhea);
    print_level_if_available (fid, "x16a_dhea"      , p.steroid_profile.x16a_dhea);
    print_level_if_available (fid, "x5_pt"          , p.steroid_profile.x5_pt);
    print_level_if_available (fid, "all_5pd"        , p.steroid_profile.all_5pd);
    print_level_if_available (fid, "tha"            , p.steroid_profile.tha);
    print_level_if_available (fid, "x5a_tha"        , p.steroid_profile.x5a_tha);
    print_level_if_available (fid, "thb"            , p.steroid_profile.thb);
    print_level_if_available (fid, "x5a_thb"        , p.steroid_profile.x5a_thb);
    print_level_if_available (fid, "x3a5b_thaldo"   , p.steroid_profile.x3a5b_thaldo);
    print_level_if_available (fid, "thdoc"          , p.steroid_profile.thdoc);
    print_level_if_available (fid, "x5a_thdoc"      , p.steroid_profile.x5a_thdoc);
    print_level_if_available (fid, "pd"             , p.steroid_profile.pd);
    print_level_if_available (fid, "x3a5a_17hp"     , p.steroid_profile.x3a5a_17hp);
    print_level_if_available (fid, "x17_hp"         , p.steroid_profile.x17_hp);
    print_level_if_available (fid, "pt"             , p.steroid_profile.pt);
    print_level_if_available (fid, "pt_one"         , p.steroid_profile.pt_one);
    print_level_if_available (fid, "ths"            , p.steroid_profile.ths);
    print_level_if_available (fid, "f"              , p.steroid_profile.f);
    print_level_if_available (fid, "x6b_oh_cortisol", p.steroid_profile.x6b_oh_cortisol);
    print_level_if_available (fid, "thf"            , p.steroid_profile.thf);
    print_level_if_available (fid, "x5a_thf"        , p.steroid_profile.x5a_thf);
    print_level_if_available (fid, "a_cortol"       , p.steroid_profile.a_cortol);
    print_level_if_available (fid, "b_cortol"       , p.steroid_profile.b_cortol);
    print_level_if_available (fid, "x11b_oh_andro"  , p.steroid_profile.x11b_oh_andro);
    print_level_if_available (fid, "x11b_oh_etio"   , p.steroid_profile.x11b_oh_etio);
    print_level_if_available (fid, "e"              , p.steroid_profile.e);
    print_level_if_available (fid, "the"            , p.steroid_profile.the);
    print_level_if_available (fid, "a_cortolone"    , p.steroid_profile.a_cortolone);
    print_level_if_available (fid, "b_cortolone"    , p.steroid_profile.b_cortolone);
    print_level_if_available (fid, "x11_oxo_etio"   , p.steroid_profile.x11_oxo_etio);
end

% If there is no data available for a particular steroid it has a value
% of NaN in the profile. We don't want to print these, so this function
% skips a steroid if it's value is NaN, and prints a warning on stderr
% instead.
function print_level_if_available (fid, steroid_name, value)
    if (! isnan (value))
        fprintf (fid, "%s=%d\n", steroid_name, value);
    else
        warning ("No data for %s. Skipping.\n", steroid_name);
    endif
end

% vim: ts=4 sw=4 et

% Function to print out the steroid levels given an array of profile
% structures.

function print_profiles (profiles)
    printf ("%d patients.\n", length (profiles));

    for (index = 1:length (profiles))
        printf ("patient %d\n", index);
        print_profile (profiles (index));
    endfor
end

function print_profile (p)
    % Don't get under the illusion that I meticulously alligned all of
    % these columns; I used visual block select in Vim to yank and paste
    % and it automagically came out like this :)
    %
    % Need print_if_not_nan()
    print_level_if_available ("an"             , p.steroid_profile.an);
    print_level_if_available ("et"             , p.steroid_profile.et);
    print_level_if_available ("dhea"           , p.steroid_profile.dhea);
    print_level_if_available ("x16a_dhea"      , p.steroid_profile.x16a_dhea);
    print_level_if_available ("x5_pt"          , p.steroid_profile.x5_pt);
    print_level_if_available ("all_5pd"        , p.steroid_profile.all_5pd);
    print_level_if_available ("tha"            , p.steroid_profile.tha);
    print_level_if_available ("x5a_tha"        , p.steroid_profile.x5a_tha);
    print_level_if_available ("thb"            , p.steroid_profile.thb);
    print_level_if_available ("x5a_thb"        , p.steroid_profile.x5a_thb);
    print_level_if_available ("x3a5b_thaldo"   , p.steroid_profile.x3a5b_thaldo);
    print_level_if_available ("thdoc"          , p.steroid_profile.thdoc);
    print_level_if_available ("x5a_thdoc"      , p.steroid_profile.x5a_thdoc);
    print_level_if_available ("pd"             , p.steroid_profile.pd);
    print_level_if_available ("x3a5a_17hp"     , p.steroid_profile.x3a5a_17hp);
    print_level_if_available ("x17_hp"         , p.steroid_profile.x17_hp);
    print_level_if_available ("pt"             , p.steroid_profile.pt);
    print_level_if_available ("pt_one"         , p.steroid_profile.pt_one);
    print_level_if_available ("ths"            , p.steroid_profile.ths);
    print_level_if_available ("f"              , p.steroid_profile.f);
    print_level_if_available ("x6b_oh_cortisol", p.steroid_profile.x6b_oh_cortisol);
    print_level_if_available ("thf"            , p.steroid_profile.thf);
    print_level_if_available ("x5a_thf"        , p.steroid_profile.x5a_thf);
    print_level_if_available ("a_cortol"       , p.steroid_profile.a_cortol);
    print_level_if_available ("b_cortol"       , p.steroid_profile.b_cortol);
    print_level_if_available ("x11b_oh_andro"  , p.steroid_profile.x11b_oh_andro);
    print_level_if_available ("x11b_oh_etio"   , p.steroid_profile.x11b_oh_etio);
    print_level_if_available ("e"              , p.steroid_profile.e);
    print_level_if_available ("the"            , p.steroid_profile.the);
    print_level_if_available ("a_cortolone"    , p.steroid_profile.a_cortolone);
    print_level_if_available ("b_cortolone"    , p.steroid_profile.b_cortolone);
    print_level_if_available ("x11_oxo_etio"   , p.steroid_profile.x11_oxo_etio);

    printf ("\n");
end

% If there is no data available for a particular steroid it has a value
% of NaN in the profile. We don't want to print these, so this function
% skips a steroid if it's value is NaN, and prints a warning on stderr
% instead.
function print_level_if_available (steroid_name, value)
    if (! isnan (value))
        printf ("%s=%d\n", steroid_name, value);
    else
        fprintf (stderr, "Warning: No data for %s. Skipping.\n", 
          steroid_name);
    endif
end

% vim: ts=4 sw=4 et

function [name code] = get_chosen_classifier (argument_list)
    % name = get_chosen_classifier (argument_list)
    %
    % Returns the filename of the classifier to load, as specified in the
    % command line options that were given to the script, which are passed
    % to this function via its single parameter.

    found = false;
    names = ["classifier_19steroids.mat"; "classifier_32steroids.mat"; ...
        "classifier_lcms.mat"; "classifier_3steroids.mat"];

    % step through the command line options searching for a token matching
    % "-c" or "--classifier".
    for argument_index = 1 : length (argument_list)
        if (strcmp (argument_list {argument_index}, "-c") || ...
          strcmp (argument_list {argument_index}, "--classifier"))
            found = true;
            break;
        endif
    endfor

    % check that we found a classifier argument. If not, print a message
    % to tell the user that they need to specify a classifier.
    if (!found)
        error ("No classifier specified. You must specify a classifier as \
          a command line argument of the form:\n \
          -c <number> | --classifier <number>\n");
    endif

    % the classifier code should follow the -c/--classifier flag.
    classifier_code = str2num (argument_list {argument_index + 1});
    name = names (classifier_code, :);
    code = classifier_code;
endfunction

% vim: ts=4 sw=4 et

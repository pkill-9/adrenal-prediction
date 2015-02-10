function write_patient_data (file_handle, data)
% Function to print the metadata around a urine sample into a file. The
% information printed could include the patients name, id, dob;
% information that is useful to determine that, for example, test input
% 00002.in and expected output 00002.exp really do correspond to the
% same urine sample.

    fdisp (file_handle, cstrcat ("patient: ", data.patient));
    fdisp (file_handle, cstrcat ("index: ", data.index));
    fdisp (file_handle, cstrcat ("data type: ", num2str (data.data_type)));
    fdisp (file_handle, cstrcat ("total volume: ", num2str (data.total_volume)));
    fdisp (file_handle, cstrcat ("dob: ", num2str (data.dob)));
    fdisp (file_handle, cstrcat ("date of collection: ", num2str (data.date_of_collection)));
    fdisp (file_handle, cstrcat ("date of analysis: ", num2str (data.date_of_analysis)));

endfunction

% vim: ts=4 sw=4 et

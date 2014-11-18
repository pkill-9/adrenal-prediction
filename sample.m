function this = sample (number,index,id,dob,doc,doa,data_type,total_volume,data)
            %% Constructor
                this.number = number;
                this.index = index;
                this.id = id;
                this.dob = dob;
                this.doc = doc;
                this.doa = doa;
                if (ismember(data_type,[1 2]) || isnan(data_type))
                    this.data_type = data_type;
                end
                this.total_volume = total_volume;
                this.steroid_profile = data;
            end

TARGET = '/opt'
switch = '/opt/.enable'

function ToAscii(s)
   -- http://www.lua.org/manual/5.1/manual.html#pdf-string.gsub
   -- https://groups.google.com/d/msg/orthanc-users/qMLgkEmwwPI/6jRpCrlgBwAJ
   return s:gsub('[^a-zA-Z0-9-/-: ]', '_')
end

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

function OnStableStudy(studyId, tags, metadata)
    if file_exists(switch)==true then
        print('New subject is now stable. Start writing.')
        local flag
        local series = ParseJson(RestApiGet('/studies/' .. studyId)) ['Series']
        for j, series in pairs(series) do
            
            local instances = ParseJson(RestApiGet('/series/' .. series)) ['Instances']
            
            -- prepare target path
           local patientTags = ParseJson(RestApiGet('/series/' .. series .. '/patient')) ['MainDicomTags']
           local studyTags = ParseJson(RestApiGet('/series/' .. series .. '/study')) ['MainDicomTags']
           local seriesTags = ParseJson(RestApiGet('/series/' .. series)) ['MainDicomTags']

            local path = ToAscii(TARGET .. '/' .. 
                                  patientTags['PatientName'] .. '/' ..
                                  studyTags['StudyDate'] .. ' - ' .. studyTags['StudyDescription'] .. '/' ..
                                  seriesTags['SeriesDescription'])
            os.execute('mkdir -p "' .. path .. '"')
	    
            flag = ToAscii(TARGET .. '/' .. patientTags['PatientName']  .. '/busy')
            io.open(flag, 'w'):close()
	            
            for i, instance in pairs(instances) do
                  -- Retrieve the DICOM file from Orthanc
                  local dicom = RestApiGet('/instances/' .. instance .. '/file')


                  -- Write to the file
                  local target = assert(io.open(path .. '/' .. instance .. '.dcm', 'wb'))
                  target:write(dicom)
                  target:close()
            end
        end
        print(flag .. ' writing completed')
        os.remove(flag)
    else
            print('Transfer is disabled')
    end
end

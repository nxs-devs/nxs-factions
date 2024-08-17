Config = {
    --  MENU  --
    IconColor = '#00ADED',
    MenuPosition = 'top-right',

    --  MARKERS  --
    MarkerType = 21, -- to active custom markers you have to put this -1
    MarkerDrawDistance = 3,
    InteractDistance = 2,
    MarkerSize = vector3(0.8, 0.8, 0.8),
    MarkerColor = { r = 255, g = 255, b = 255 },

    -- IF YOU WANT CUSTOM MARKERS 
    MarkerYTD = false, -- this is the texture dict

    InventoryMarker = false,  -- if you don't want this put false
    WardRobeMarker = false, -- if you don't want this put false
    BossMenuMarker = false, -- if you don't want this put false
    Vehicle1Marker = false, -- if you don't want this put false
    Vehicle2Marker = false, -- if you don't want this put false

    --  IF YOU DON'T PUT GRADES IN THE MENU THIS WILL BE THE DEFAULT GRADES  --
    IfNotGrades = {
        { grade = 0, name = 'grade0', label = 'Role 0', salary = '104' },
        { grade = 1, name = 'grade1', label = 'Role 1', salary = '104' },
        { grade = 2, name = 'viceboss', label = 'Vice Boss', salary = '104' },
        { grade = 3, name = 'boss', label = 'Boss', salary = '104' },
    },
    
    CreateCommand = 'creafazione',
    EditCommand = 'modificafazione',
    AutoSetJobs = true, -- put this false if you don't want to set you the job you created

    AdminGroups = {
        'headadmin',
        'admin'
    }

}

YourBossmenuFunc = function(job)
    print('Bossmenu: '..job)
    -- HERE YOU HAVE TO PUT YOUR BOSSMENU TRIGGER  --
end

YourWardRobeFunc = function(job)
    print('Camerino: '..job)
    -- HERE YOU HAVE TO PUT YOUR BOSSMENU TRIGGER  --
end

FunzioneTextUI = function(msg)
    lib.showTextUI('[E] - '..msg, {
        position = 'right-center',
        icon = icona,
        style = {
            borderRadius = 10,
            backgroundColor = 'rgba(0, 0, 0, 0.5)',
            color = '#ffffff',
        },
    })
end

Notify = function(msg)
    -- HERE YOU HAVE TO PUT YOUR NOTIFICATIONS  --
    ESX.ShowNotification(msg)
end
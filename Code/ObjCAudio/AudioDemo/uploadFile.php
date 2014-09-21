    <?php
        $folder = "upload/";

        if (is_uploaded_file($_FILES['userfile']['tmp_name']))  {   
        if (move_uploaded_file($_FILES['userfile']['tmp_name'], $folder.$_FILES['userfile']['name'])) {
            Echo "File uploaded";
        } else {
            Echo "File not moved to destination folder. Check permissions";
        };
        } else {
            Echo "File is not uploaded.";
        }; 
    ?>
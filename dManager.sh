#!/bin/bash

BACKTITLE="Download Manager by MUSTAFA AYKAÇ & BURAK ERDOĞAN "
TITLE="Download Manager"
MENU="Select from the options below"
DOWNLOADS="$HOME/Downloads/"
SCREEN_HEIGHT=25
SCREEN_WIDTH=50
CHOICE_HEIGHT=7
LINK_HEIGHT=10
LINK_WIDTH=40
DOWNLOADS_HEIGHT=25
DOWNLOADS_WIDTH=40

SELECT=""

input=""

OPTIONS=(1 "Set the Downloads directory"
         2 "Enter the Links"
         3 "Download Files"
         4 "History of Downloads"
         5 "Remove History"
         6 "See Downloaded Files"
         7 "Exit")



#function for setting the downloads directory path
# input, error and dialog output operations, creating file descriptor for the input value

function set_path {
DOWNLOADS=$(\
dialog --inputbox "Downloads directory:(Current path: $DOWNLOADS)" $SCREEN_HEIGHT $SCREEN_WIDTH \
 3>&1 1>&2 2>&3 3>&- \
)
}

#function for entering url of the file that the user want to download
# input, error and dialog output operations, creating file descriptor for the input value

function enter_link {
while [[ $input != 0 ]];
input=$(\
dialog --inputbox "Enter the link: (Enter 0 to exit)" $LINK_HEIGHT $LINK_WIDTH \
 3>&1 1>&2 2>&3 3>&- \
)
#the link entered is saved into text file here
if [[ $input != 0 ]]; then
    echo $input >> $HOME/links.txt
else
    input=""
    break
fi

do
    continue

done

clear
}

#function for seeing the history of downloaded links

function see_history() {
    dialog --textbox "$HOME/history.txt" $SCREEN_HEIGHT $SCREEN_WIDTH
}

function see_downloads(){
    dialog --title "Downloaded Files" --msgbox "$(ls $HOME/Downloads )" $DOWNLOADS_HEIGHT $DOWNLOADS_WIDTH
}

#function for deleting the history of downloaded links

function remove_history() {
    > $HOME/history.txt
}

#function for downloading files to specified directory
function download {
wget -i $HOME/links.txt -P $DOWNLOADS -q 2>&1 | \
dialog --gauge "Downloading..." $SCREEN_HEIGHT $SCREEN_WIDTH
cat $HOME/links.txt >> $HOME/history.txt  #saved links are copied into history
notify-send "Download successful" "Files are downloaded"
}


function quit() {
if [[ -e $HOME/links.txt ]]; then
    rm $HOME/links.txt  #the links are removed after quiting
fi
    exit
}

while [[ $SELECT != 0 ]]; do
SELECT=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $SCREEN_HEIGHT $SCREEN_WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)  # for std error output and controlling terminal of the current process


case $SELECT in
        1)
            set_path
            ;;
        2)
            enter_link
            ;;
        3)
            download
            ;;
        4)
	    see_history
	    ;;
        5)
            remove_history
            ;;
        6)
            see_downloads
            ;;
        7)
            quit
            ;;
esac
done

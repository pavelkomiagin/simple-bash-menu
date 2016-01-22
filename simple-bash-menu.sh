#!/bin/bash

##########################################################################
#                                                                        #
# You can use this script as template to build your own menu in console  #
#                                                                        #
##########################################################################

function show_main_title {
  # Set a foreground colour using ANSI escape
  tput setaf 3

  echo "
    ███████╗██╗███╗   ███╗██████╗ ██╗     ███████╗    ██████╗  █████╗ ███████╗██╗  ██╗    ███╗   ███╗███████╗███╗   ██╗██╗   ██╗
    ██╔════╝██║████╗ ████║██╔══██╗██║     ██╔════╝    ██╔══██╗██╔══██╗██╔════╝██║  ██║    ████╗ ████║██╔════╝████╗  ██║██║   ██║
    ███████╗██║██╔████╔██║██████╔╝██║     █████╗      ██████╔╝███████║███████╗███████║    ██╔████╔██║█████╗  ██╔██╗ ██║██║   ██║
    ╚════██║██║██║╚██╔╝██║██╔═══╝ ██║     ██╔══╝      ██╔══██╗██╔══██║╚════██║██╔══██║    ██║╚██╔╝██║██╔══╝  ██║╚██╗██║██║   ██║
    ███████║██║██║ ╚═╝ ██║██║     ███████╗███████╗    ██████╔╝██║  ██║███████║██║  ██║    ██║ ╚═╝ ██║███████╗██║ ╚████║╚██████╔╝
    ╚══════╝╚═╝╚═╝     ╚═╝╚═╝     ╚══════╝╚══════╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝    ╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝
                                                                                                                                "

  tput sgr0
}

function show_main_menu {
  # clear the screen
  tput clear

  # Move cursor to screen location X,Y (top left is 0,0)
  tput cup 1 15

  show_main_title

  tput cup 10 15
  # Set reverse video mode
  tput rev
  echo "WHAT DO YOU WANT TO DO?"
  tput sgr0

  tput cup 12 15
  echo "1. Generate Fake emails"

  tput cup 13 15
  echo "2. Buy all guitars from ebay"

  tput cup 14 15
  echo "3. Make a cup of tea"

  tput cup 15 15
  echo "4. I want to quit"

  # Set bold mode
  tput bold
  tput cup 17 15

  # Get entered number in choice variable
  read -p "Enter your choice [1-4] " choice

  tput clear
  tput sgr0

  case "$choice" in
    "1") show_action_menu "GENERATE FAKE EMAILS. PLEASE WAIT..." "generate_fake_emails"
         ;;
    "2") show_action_menu "BUY ALL GUITARS FROM EBAY. PLEASE WAIT..." "buy_all_guitars"
         ;;
    "3") show_action_menu "MAKE A CUP OF COFFEE. PLEASE WAIT..." "make_coffee"
         ;;
    "4") echo "Exit..."
         exit 0
         ;;
    *) echo "Wrong choice... Please try again."
       show_main_menu
       ;;
  esac
}

function show_action_menu {
  # $1 = Action title
  # $2 = Action name
  tput clear

  tput cup 1 15

  show_main_title

  tput cup 10 15

  tput rev
  echo $1
  tput sgr0

  tput bold
  tput cup 12 15

  run_task $2
}

function run_task {
  echo 'Task start...'

  tput sgr0

  task_name=$1

  case "$task_name" in
    "generate_fake_emails")
      # Change the line below to your action
      #RAILS_ENV=production rake generate_fake_emails
      echo "Here will be an output of this rake task"
      ;;
    "buy_all_guitars")
      #RAILS_ENV=production rake buy_all_guitars
      echo "Here will be an output of this rake task"
      ;;
    "make_coffee")
      #RAILS_ENV=production rake make_coffee
      echo "Here will be an output of this rake task"
      ;;
    *) echo "Error. Action '$task_name' doesn't exist."
       exit 0
       ;;
  esac

  # Calculate current position of the cursor
  extract_current_cursor_position last_position
  last_line_number=${last_position[0]}

  tput cup $[$last_line_number + 1] 15

  tput bold
  echo 'Task end.'
}

#############################
#  Helpers  #
#############################

# http://askubuntu.com/questions/366103/saving-more-corsor-positions-with-tput-in-bash-terminal
function extract_current_cursor_position {
    export $1
    exec < /dev/tty
    oldstty=$(stty -g)
    stty raw -echo min 0
    echo -en "\033[6n" > /dev/tty
    IFS=';' read -r -d R -a pos
    stty $oldstty
    eval "$1[0]=$((${pos[0]:2} - 2))"
    eval "$1[1]=$((${pos[1]} - 1))"
}

# Start point
show_main_menu

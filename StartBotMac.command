#!/bin/bash
#!/usr/bin/env node console.log('Node.js found.')
[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"
repeat="n"

if [ -f bot.js ]
then
	echo Checking files... \(1/6\)
else
	echo
	echo ----------------------------------------------------------
	echo
	echo "bot.js" not found. Please rename the file or download it.
	echo
	echo ----------------------------------------------------------
	echo
	echo
	echo https://github.com/Edude42/WrenchBot/blob/master/bot.js
	echo
	echo
	echo Press any key...
	read -n 1 -s
	exit 0
fi

if [ -d node_modules ]
then
	echo Checking files... \(2/6\)
else
	echo
	echo -------------------------------------
	echo
	echo NPM Modules not found. Installing...
	echo
	echo -------------------------------------
	echo
	sudo npm install
	echo
	echo If you are getting permission errors, please install and set up sudo.
	echo
	echo If there were any errors, either contact edude@edude.xyz,
	echo or make sure you have the latest version of Java, Python, g++ and
	echo you successfully installed Node.js and npm.
	echo
	echo How to: https://github.com/Edude42/WrenchBot/wiki/Getting-Started#OSX
	echo
	echo Press any key...
	read -n 1 -s
fi

if [ -d commands ]
then
	echo Checking files... \(3/6\)
else
	echo
	echo -----------------------------------------
	echo
	echo Commands not found. Please download them.
	echo
	echo -----------------------------------------
	echo
	echo
	echo https://github.com/Edude42/WrenchBot/tree/master/commands
	echo
	echo
	echo Press any key...
	read -n 1 -s
	exit 0
fi

if [ -f auth.json ]
then
	echo Checking files... \(4/6\)
else
	echo
	echo --------------------------------------------
	echo
	echo auth.json not found. Please create the file.
	echo
	echo --------------------------------------------
	echo
	echo
	echo How to: https://github.com/Edude42/WrenchBot/wiki/Auth-Key
	echo
	echo
	echo Press any key...
	read -n 1 -s
	exit 0
fi

if [ -f config.json ]
then
	echo Checking files... \(5/6\)
else
	echo
	echo ------------------------------------------------
	echo
	echo config.json not found. Please download the file.
	echo
	echo ------------------------------------------------
	echo
	echo
	echo Download: https://github.com/Edude42/WrenchBot/blob/master/config.json
	echo
	echo
	echo Press any key...
	read -n 1 -s
	exit 0
fi

if [ -f node_modules/discord.js-commando/src/commands/util/eval.js ]
then
	echo Checking files... \(5/6\)
	echo 
	echo --------------------------------
	echo
	echo eval command found. Disabling...
	echo
	echo --------------------------------
	echo
	echo
	cp node_modules/discord.js-commando/src/commands/util/eval.js eval.js.bak
	cp eval.js node_modules/discord.js-commando/src/commands/util
	echo
	echo
	echo Done! Proceding...
	echo Checking files... \(6/7\)
else
	echo Checking files... \(6/7\)
fi

if [ -f package.json ]
then
	echo Checking files... \(7/7\)
else
	echo
	echo -------------------------------------------------
	echo
	echo package.json not found. Please download the file.
	echo
	echo -------------------------------------------------
	echo
	echo
	echo Example: https://github.com/Edude42/WrenchBot
	echo
	echo
	echo Press any key...
	read -n 1 -s
	exit 0
fi

if [ -f autorestart ]
then
	while true
	do
	echo
	echo REPEAT ON
	echo
	node bot.js
	echo
	echo Crash detected... Restarting in 15 seconds.
	sleep 15
	done
else
	echo
	echo If you put a file named "autorestart" \(no extension\),
	echo this prompt will go away and will always restart.
	echo
	read -p 'Would you like to automatically restart the bot if it crashes? (y/n) ' repeat
	echo
	echo Done! Starting bot...
	echo 
	reset
	echo
	echo If the command "node" was not found, that means
	echo you either don\'t have Node.js installed, or
	echo you don\'t have it set up in your environment.
	echo
	if [ $repeat == "y" ]
	then
		while true
		do
		echo
		echo REPEAT ON
		echo
		node bot.js
		echo
		echo Crash detected... Restarting in 15 seconds.
		sleep 15
	done
	else
		echo
		echo REPEAT OFF
		echo
		node bot.js
		exit 0
	fi
fi
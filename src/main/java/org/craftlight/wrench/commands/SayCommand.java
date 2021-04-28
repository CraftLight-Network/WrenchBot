package org.craftlight.wrench.commands;

import com.github.kaktushose.jda.commands.annotations.Command;
import com.github.kaktushose.jda.commands.annotations.CommandController;
import com.github.kaktushose.jda.commands.entities.CommandEvent;

@CommandController
public class SayCommand {
    @Command("say")
    public void onSay(CommandEvent event, String ...message) {
        // Delete the message
        event.getMessage().delete();

        // Parrot
        event.reply(String.join(" ", message));
    }
}

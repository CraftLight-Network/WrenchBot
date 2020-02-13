// Get logger
const { log } = require("./logger.js");

// Define and require modules
const { stripIndents } = require("common-tags");
const AntiSpam = require("discord-anti-spam");
const { guildConfig } = require("./enmap.js");
const { RichEmbed } = require("discord.js");
const request = require("async-request");

// Format + update bad links
let badLinks = [];
async function createBadLinks() {
	// Grab the latest Unified HOSTS (Unified + Gambling + Fakenews + Porn)
	let hosts = await request("http://sbc.io/hosts/alternates/fakenews-gambling-porn/hosts");

	// Format the bad links file
	badLinks = await hosts.body
		.replace(/#.*|[0-9].[0-9].[0-9].[0-9]\s|^((?!.*\..*).)*$/gmi, "")
		.trim()
		.split("\n")
		.slice(14)
		.map(file => file.trim().replace(/\s/g, ""))
		.filter(Boolean);
	log.info("Bad links array is ready!");
	hosts = "";
}
createBadLinks();

const antiSpam = new AntiSpam({
	"warnThreshold": 5,
	"kickThreshold": 8,
	"banThreshold": 12,
	"maxInterval": 5000,
	"maxDuplicatesWarning": 5,
	"maxDuplicatesKick": 8,
	"maxDuplicatesBan": 12,
	"errorMessages": false,
	"warnMessage": "",
	"kickMessage": "**{user_tag}** has been kicked for spamming.",
	"banMessage": "**{user_tag}** has been banned for spamming."
});

antiSpam.on("spamThresholdWarn", (member) => {
	const embed = new RichEmbed()
		.setAuthor("Warning", member.displayAvatarURL)
		.addField(`Do not spam!`, stripIndents`
			The server does not want you to spam there.
			Please change your message or slow down.
		`)
		.setColor("#E3E3E3");
	member.send(embed);
});

module.exports = function automod(message) {
	if (!(guildConfig.get(message.guild.id, "automod.enabled") || message.guild)) return;

	// Shorter message content
	const content = message.content;

	// Check for spam
	if (guildConfig.get(message.guild.id, "automod.modules.spam")) checkSpam();
	async function checkSpam() {
		// Make sure there's a message
		if (content.split("").size !== 0) antiSpam.message(message);

		// Check for unique words
		const spaceFix = content.split(" ").map(s => s.trim().replace(/[ ]/g, ""));
		if (spaceFix.length / 4 < [...new Set(spaceFix)].length) return;

		// Delete and warn
		await message.delete();
		reply("spam", "spam");
	}

	// Check for invites
	if (guildConfig.get(message.guild.id, "automod.modules.invites")) checkInvites();
	async function checkInvites() {
		// Make sure there are invites
		if (!content.match("discord.gg|discordapp.com/invite")) return;

		// Delete and warn
		await message.delete();
		reply("send invite links", "invite");
	}

	// Check for bad links
	if (guildConfig.get(message.guild.id, "automod.modules.badLinks")) checkBadLinks();
	async function checkBadLinks() {
		// Make sure there are bad links
		if (content === "" || !badLinks.some(l => content.includes(l))) return;

		// Delete and warn
		await message.delete();
		reply("send bad links", "link");
	}

	// Check for caps
	if (guildConfig.get(message.guild.id, "automod.modules.caps")) checkCaps();
	async function checkCaps() {
		// Filter out emotes
		const noEmotes = content.replace(/[\u1000-\uFFFF]+/gu, "");

		// Detect if there are just more than 5 emojis
		if (noEmotes === "" || noEmotes.replace(/[ A-Z]/g, "").length >= noEmotes.replace(/[ a-z]/g, "").length) return;

		// Delete and warn
		await message.delete();
		reply("send all caps", "caps");
	}

	// Reply function
	function reply(warning, warningCode) {
		const embed = new RichEmbed()
			.setAuthor("Warning", message.author.displayAvatarURL)
			.addField(`Do not ${warning}!`, stripIndents`
				The server ${message.guild.name} does not want you to ${warning} there.
				If this was a mistake, you may edit your message without the ${warningCode}.
			`)
			.addField("Original Message", message)
			.setFooter(`Action done by AutoMod`)
			.setColor("#E3E3E3");
		message.author.send(embed);
	}
};
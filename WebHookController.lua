local httpService = game:GetService("HttpService")
local lume = loadstring(game:HttpGet("https://raw.githubusercontent.com/rxi/lume/master/lume.lua", true))()

export type Embed = {
	title: string,
	description: string,
	color: number?,
	fields: {
		name: string,
		value: string,
		inline: boolean,
	}?,
	footer: {
		text: string,
	}?,
	author: {
		name: string,
		url: string?,
		icon_url: string?,
	}?,
	image: { url: string? },
	thumbnail: { url: string? },
}

local EmbedBuilder = {}
EmbedBuilder.__index = EmbedBuilder

function EmbedBuilder.new(data: { title: string, description: string?, image: string?, thumnail: string? })
	local self = setmetatable({}, EmbedBuilder)
	local embed: Embed = data or { title = "", description = "", image = { url = "" }, thumbnail = { url = "" } }

	self.embed = embed
	return self
end

function EmbedBuilder:AddField(data: { name: string, value: string | number, inline: boolean? })
	self.embed.fields = self.embed.fields or {}

	lume.push(self.embed.fields, data)
	return self
end

function EmbedBuilder:SetAuthor(data: { name: string, url: string?, icon: string? })
	self.embed.author = data
	return self
end

function EmbedBuilder:SetFooter(data: { text: string })
	self.embed.footer = data
	return self
end

function EmbedBuilder:SetColor(color: Color3)
	self.embed.color = math.floor(color.r * 255) * 256 ^ 2 + math.floor(color.g * 255) * 256 + math.floor(color.b * 255)
	return self
end

local Webhook = {}
Webhook.__index = Webhook

function Webhook.new(url: string)
	local self = setmetatable({}, Webhook)
	self.url = url
	return self
end

function Webhook:Send(content: string, embeds: { Embed }?)
	local request = http.request
	if not request then
		warn("Executor doesnt support requests not found")
		return
	end
	request({
		Url = self.url,
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json" },
		Body = httpService:JSONEncode({ content, embeds }),
	})
end

return Webhook, EmbedBuilder

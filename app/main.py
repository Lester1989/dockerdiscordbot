import asyncio
import os
from interactions import Client, Intents, listen
from interactions import slash_command, SlashContext

bot = Client(intents=Intents.DEFAULT)

@listen()
async def on_ready():
    """
    This event is called when the bot is ready to respond to commands
    """
    print("Ready")
    print(f"This bot is owned by {bot.owner}")


@listen()
async def on_message_create(event):
    """
    This event is called when a message is sent in a channel the bot can see
    """
    print(f"message received: {event.message.content}")


@slash_command(name="my_command", description="My first command :)")
async def my_command_function(ctx: SlashContext):
    """
    A slash command that sends a "Hello World" message to the channel
    """
    await ctx.send("Hello World")

@slash_command(name="my_long_command", description="My second command :)")
async def my_long_command_function(ctx: SlashContext):
    """
    A slash command that defers the response, waits for 10 minutes, then sends a "Hello World" message to the channel
    """
    await ctx.defer()

    await asyncio.sleep(600)

    await ctx.send("Hello World")

if __name__ == "__main__":
    if "DISCORDTOKEN" not in os.environ:
        print("Please set the DISCORDTOKEN environment variable to your bot token")
        exit(1)
    bot.start(os.environ.get("DISCORDTOKEN"))
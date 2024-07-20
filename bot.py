import asyncio
import logging

import asyncpg
from aiogram import Dispatcher, Bot
from aiogram.fsm.storage.memory import MemoryStorage
from aiogram_dialog import setup_dialogs, Dialog

from config_reader import config
from handlers import start, maintenance_mode
from markups import format_title_dialog, format_story_dialog


async def main():
    bot = Bot(token=config.bot_token.get_secret_value())

    async with asyncpg.create_pool(host=config.host.get_secret_value(),
                                   port=config.port,
                                   user=config.user.get_secret_value(),
                                   database=config.database.get_secret_value(),
                                   password=config.password.get_secret_value(),
                                   min_size=1,
                                   max_size=10) as pool:

        storage = MemoryStorage() # For what is there storage here?
        dp = Dispatcher(pool=pool,
                        maintenance_mode=False,
                        storage=storage)

        dp.include_router(maintenance_mode.maintenance_router)
        dp.include_router(start.router)

        dialog_titles = await format_title_dialog(pool_sql=pool, len_page=3)
        dp.include_router(dialog_titles)

        dialog_story = format_story_dialog()
        dp.include_router(dialog_story)

        setup_dialogs(dp)

        await dp.start_polling(bot)


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)

    asyncio.run(main())

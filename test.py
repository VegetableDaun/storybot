from aiogram import Bot, Dispatcher
from aiogram.filters import Command
from aiogram.filters.state import State, StatesGroup
from aiogram.fsm.storage.memory import MemoryStorage
from aiogram.types import Message
from aiogram_dialog import (
    Dialog, DialogManager, setup_dialogs, StartMode, Window,
)
from aiogram_dialog.widgets.kbd import Button
from aiogram_dialog.widgets.text import Const, Format

from config_reader import config


class MySG(StatesGroup):
    main = State()


async def get_id(**kwargs):
    dialog_manager: DialogManager = kwargs['dialog_manager']
    fsm_storage: MemoryStorage = kwargs['fsm_storage']
    event_from_user: dict = kwargs['event_from_user']

    print(dialog_manager.dialog_data)
    # print(fsm_storage.reader_list)
    print(event_from_user)

    return {'id': event_from_user.username}


buttons = [Format("Hello, {id}"), Button(Const("Useless button"), id='nothing')]

main_window = Window(*buttons, state=MySG.main, getter=get_id)

dialog = Dialog(main_window)
storage = MemoryStorage()
bot = Bot(token=config.bot_token.get_secret_value())
dp = Dispatcher(storage=storage)
dp.include_router(dialog)

setup_dialogs(dp)

if __name__ == '__main__':
    dp.run_polling(bot, skip_updates=True)

@dp.message(Command("start"))
async def start(message: Message, dialog_manager: DialogManager):
    await dialog_manager.start(MySG.main, mode=StartMode.RESET_STACK)

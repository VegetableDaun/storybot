import asyncpg
from aiogram import Router, types
from aiogram.filters.command import Command
from aiogram_dialog import DialogManager
from aiogram_dialog import StartMode

from markups import MySG

from SQL_commands import SQL_sign_up, SQL_login

router = Router()


@router.message(Command('start'))
async def start_handler(message: types.Message, pool: asyncpg.Pool, dialog_manager: DialogManager):
    async with pool.acquire() as session:
        user_in = await session.fetch(SQL_login.format(message.from_user.id))

    if len(user_in) == 1:
        await message.answer(f"С возвращением {message.from_user.username} StoryBot."
                             f"Приятного чтения 😁")
    else:
        async with pool.acquire() as session:
            async with session.transaction():
                await session.execute(SQL_sign_up.format(message.from_user.id))

        await message.answer(f"Добро пожаловать в StoryBot, {message.from_user.username}! "
                             f"Выберите свою первую историю для прохождения!"
                             f"Приятного чтения 😁")

    await dialog_manager.start(MySG.window0, mode=StartMode.RESET_STACK, data={'pool' : pool})



# def new_data(text: str):
#     def decorator(function):
#         inv_data = {'login': 'password', 'password': 'login'}
#
#         async def wrapper(message: types.Message, readers: dict):
#             if len(message.text.split()) == 1:
#                 return await message.answer(f"Вводимое значение должно быть в формате\n"
#                                             f"/{text} <{text}>")
#
#             data = message.text.split()[1]
#             if message.from_user.id not in readers:
#                 readers[message.from_user.id] = {'login': None, 'password': None, 'logged': False}
#                 readers[message.from_user.id][text] = data
#
#                 return await message.answer(f'Также введите /{inv_data[text]}')
#             else:
#                 readers[message.from_user.id][text] = data
#                 return await message.answer(f"login: {readers[message.from_user.id]['login']}\npassword: *********")
#
#         return wrapper
#
#     return decorator


# @router.message(Command('login'))
# @new_data("login")
# async def login_cmd():
#     pass
#
#
# @router.message(Command('password'))
# @new_data("password")
# async def password_cmd():
#     pass
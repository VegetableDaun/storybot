from aiogram import Router, types, F
from aiogram.filters import MagicData

# from aiogram.filters import BaseFilter


# class AuthFilter(BaseFilter):
#     async def __call__(self, message: types.Message, readers: dict) -> bool:
#         if message.from_user.id not in readers:
#             return True
#         else:
#             return not readers[message.from_user.id]['logged']


maintenance_router = Router()
maintenance_router.message.filter(MagicData(F.maintenance_mode.is_(True)))
maintenance_router.callback_query.filter(MagicData(F.maintenance_mode.is_(True)))


@maintenance_router.message()
async def any_message(message: types.Message):
    await message.answer("Бот в режиме обслуживания 🥹. Пожалуйста, подождите.")


@maintenance_router.callback_query()
async def any_callback(callback: types.CallbackQuery):
    await callback.answer(
        text="Бот в режиме обслуживания 🥹. Пожалуйста, подождите",
        show_alert=True
    )

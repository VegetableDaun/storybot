import asyncpg
from aiogram.filters.state import State, StatesGroup
from aiogram.types import CallbackQuery
from aiogram_dialog import Dialog, DialogManager
from aiogram_dialog import Window
from aiogram_dialog.widgets.kbd import Button
from aiogram_dialog.widgets.text import Const, Format

from SQL_commands import SQL_data_short


class story_storage(StatesGroup):
    choices_1 = State()
    choices_2 = State()
    choices_3 = State()
    choices_4 = State()
    choices_5 = State()


def format_story_dialog() -> Dialog:
    list_windows = []

    for i in range(1, 6):
        in_window = [Const("???")]
        for k in range(i):
            in_window.append(Button(Format(text="{" + f'answer_{k}' + "}"), id=f"answer_{k}", on_click=get_choice))

        list_windows.append(Window(*in_window, state=getattr(story_storage, f'choices_{i}'), getter=get_answers))

    dialog = Dialog(*list_windows)

    return dialog


async def get_answers(**kwargs):
    data_sql = kwargs['dialog_manager'].start_data['data_sql']

    answers = {}
    for i in range(len(data_sql)):
        answers[f'answer_{i}'] = data_sql[i]['answer']

    return answers


async def get_choice(callback: CallbackQuery, button: Button, manager: DialogManager):
    pool: asyncpg.Pool = manager.start_data['pool']
    data_sql = manager.start_data['data_sql']

    answer_number = int(button.widget_id.split('_')[-1])

    await callback.message.answer(data_sql[answer_number]['message'])

    async with pool.acquire() as session:
        data_sql = await session.fetch(SQL_data_short.format(id_title=manager.start_data["id_title"],
                                                             state=data_sql[answer_number]['last_state']))

    manager.start_data['data_sql'] = data_sql

    await manager.switch_to(getattr(story_storage, f'choices_{len(data_sql)}'))

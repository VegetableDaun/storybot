from math import ceil
from typing import Union

import asyncpg
from aiogram.filters.state import State, StatesGroup
from aiogram.types import CallbackQuery
from aiogram_dialog import Dialog
from aiogram_dialog import Window, DialogManager
from aiogram_dialog.widgets.kbd import Button, Row
from aiogram_dialog.widgets.text import Format, Const

from SQL_commands import SQL_title, SQL_start_story, SQL_data
from markups.storyteller import story_storage


class MySG(StatesGroup):
    window0 = State()
    window1 = State()
    window2 = State()
    window3 = State()
    window4 = State()
    window5 = State()

    choice = State()


def get_title(titles: list[asyncpg.Record], page: int, len_page: int):
    return titles[page * len_page: page * len_page + len_page]


def generate_state_groups(group_prefix: str, groups_amount: int, states_amount: int) -> list:
    """
    Generates any amount of unique groups with a strict amount of states for each.
    """
    return [
        type(
            f"{group_prefix}_{n}",
            (StatesGroup,),
            {f"{n}state{nn}": State() for nn in range(states_amount)},
        )
        for n in range(groups_amount)
    ]


async def title_windows(pool_sql: asyncpg.Pool, len_page: int):
    titles = await select_titles(pool_sql)

    list_windows = []

    pages = ceil(len(titles) / len_page)

    # mda = generate_state_groups(group_prefix='MySG', groups_amount=1, states_amount=pages)
    # print(mda)
    # for i in range(pages):
    #     setattr(MySG, f'window{i}', State())
    #     getattr(MySG, f'window{i}').set_parent(MySG)

    in_window: list[Union[Format, Button, Row]] = [Format("Выберите историю для прохождения, {username}!")]
    in_window_copy = in_window.copy()

    for i in range(pages):
        if pages == 1:
            part_titles = titles
        else:
            part_titles = get_title(titles, page=i, len_page=len_page)

        for k in range(len(part_titles)):
            in_window_copy.append(Button(Const(f"{part_titles[k]['title']}"),
                                         id=f'title_{part_titles[k]["id"]}',
                                         on_click=get_choice
                                         )
                                  )

        if pages >= 2 and i == 0:
            in_window_copy.append(Button(Const("Next"), id=f"next_{i}", on_click=next_button))
        elif pages == 2 or (pages > 2 and i == pages - 1):
            in_window_copy.append(Button(Const("Back"), id=f"back_{i}", on_click=back_button))
        elif pages > 2:
            in_window_copy.append(Row(Button(Const("Back"), id=f"back_{i}", on_click=back_button),
                                      Button(Const("Next"), id=f"next_{i}", on_click=next_button)
                                      )
                                  )

            # in_window_copy.append(Button(Const("Next"), id=f"next_{i}", on_click=next_button))
            # in_window_copy.append(Button(Const("Back"), id=f"back_{i}", on_click=back_button))

        list_windows.append(Window(*in_window_copy, state=getattr(MySG, f'window{i}'), getter=get_name))
        in_window_copy = in_window.copy()

    return list_windows


def choose_window() -> Window:
    return Window(Format("Выбранная история: {dialog_data[text_button]}"),
                  Button(Const("Новое прохождение"), id="new_try", on_click=new_try),
                  Button(Const("Продолжить прохождение"), id="continue_try", on_click=continue_try),
                  Button(Const("Назад к списку историй"), id="back_to_titles", on_click=back_to_titles),
                  state=MySG.choice
                  )


async def format_title_dialog(pool_sql: asyncpg.Pool, len_page: int) -> Dialog:
    list_windows = await title_windows(pool_sql=pool_sql, len_page=len_page)
    choice = choose_window()

    list_windows.append(choice)

    dialog = Dialog(*list_windows)

    return dialog


async def select_titles(pool_sql: asyncpg.Pool):
    while True:
        async with pool_sql.acquire() as session:
            return await session.fetch(SQL_title)


async def get_name(**kwargs):
    return {'username': kwargs['event_from_user'].username}


async def back_button(callback: CallbackQuery, button: Button, manager: DialogManager):
    await manager.back()


async def next_button(callback: CallbackQuery, button: Button, manager: DialogManager):
    await manager.next()


async def get_choice(callback: CallbackQuery, button: Button, manager: DialogManager):
    manager.dialog_data['text_button'] = button.text.__getattribute__('text')
    manager.dialog_data['id_title'] = callback.data.split('_')[1]

    await manager.switch_to(state=MySG.choice, show_mode=manager.show_mode)


async def back_to_titles(callback: CallbackQuery, button: Button, manager: DialogManager):
    # await manager.switch_to(manager.current_stack().pop(), show_mode=manager.show_mode)
    await manager.back()


async def new_try(callback: CallbackQuery, button: Button, manager: DialogManager):
    pool: asyncpg.Pool = manager.start_data['pool']

    async with pool.acquire() as session:
        await session.execute(SQL_start_story.format(callback.from_user.id,
                                                     manager.dialog_data['id_title'])
                              )

        data_sql = await session.fetch(SQL_data.format(id_title=manager.dialog_data['id_title'],
                                                       id_user=callback.from_user.id)
                                       )

    await manager.start(getattr(story_storage, f'choices_{len(data_sql)}'), data={'pool': pool,
                                                                                  'data_sql': data_sql,
                                                                                  'id_title': manager.dialog_data['id_title']})


async def continue_try(callback: CallbackQuery, button: Button, manager: DialogManager):
    pool: asyncpg.Pool = manager.start_data['pool']

    async with pool.acquire() as session:
        data_sql = await session.fetch(SQL_data.format(id_title=manager.dialog_data['id_title'],
                                                       id_user=callback.from_user.id))

    await manager.start(getattr(story_storage, f'choices_{len(data_sql)}'), data={'pool': pool,
                                                                                  'data_sql': data_sql,
                                                                                  'id_title': manager.dialog_data['id_title']})

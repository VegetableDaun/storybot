INSERT INTO list_stories (title)
VALUES ('testStory1'),
       ('testStory2'),
       ('testStory3'),
       ('testStory4'),
       ('testStory5'),
       ('testStory6'),
       ('testStory7');

INSERT INTO line_story_1 (start_state, last_state, answer, award, restrict, condition_points, message)
VALUES ('0.0', '0.1', 'answer(0.0 -> 0.1)', '{"WATER": 1, "EARTH": 0, "FIRE": 0, "AIR": 0}',
        '[]', '[]', 'text_(0.0 -> 0.1)'),
    ('0.0', '0.2', 'answer(0.0 -> 0.2)', '{"WATER": 0, "EARTH": 1, "FIRE": 0, "AIR": 0}',
        '[]', '[]', 'text_(0.0 -> 0.2)'),
    ('0.0', '0.3', 'answer(0.0 -> 0.3)', '{"WATER": 0, "EARTH": 0, "FIRE": 1, "AIR": 0}',
        '[]', '[]', 'text_(0.0 -> 0.3)'),
    ('0.0', '0.4', 'answer(0.0 -> 0.4)', '{"WATER": 0, "EARTH": 0, "FIRE": 0, "AIR": 1}',
        '[]', '[]', 'text_(0.0 -> 0.4)'),



    ('0.1', '0.5', 'answer(0.1 -> 0.5)', '{"WATER": 0, "EARTH": 0, "FIRE": 0, "AIR": 0}',
        '["0.4"]', '[]', 'text_(0.1 -> 0.5)'),
    ('0.2', '0.5', 'answer(0.2 -> 0.5)', '{"WATER": 0, "EARTH": 0, "FIRE": 0, "AIR": 0}',
        '["0.3"]', '[]', 'text_(0.2 -> 0.5)'),
    ('0.3', '0.5', 'answer(0.3 -> 0.5)', '{"WATER": 0, "EARTH": 0, "FIRE": 0, "AIR": 0}',
        '["0.2"]', '[]', 'text_(0.3 -> 0.5)'),
    ('0.4', '0.5', 'answer(0.4 -> 0.5)', '{"WATER": 0, "EARTH": 0, "FIRE": 0, "AIR": 0}',
        '["0.1"]', '[]', 'text_(0.4 -> 0.5)'),

    ('0.4', '0.5', 'answer(0.4 -> 0.5)', '{"WATER": 1, "EARTH": 1, "FIRE": 1, "AIR": 1}',
        '["0.1"]', '{"WATER": 0, "EARTH": 0, "FIRE": 0, "AIR": 1}', 'text_(0.4 -> 0.5)');
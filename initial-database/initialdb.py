import sqlite3, requests
from sqlite3 import Error
import time
import json
# from random import * # just for testing

def create_connection(db_file):
  """ create a connection to a SQLite database """
  conn = None
  try:
    conn = sqlite3.connect(db_file)
  except Error as e:
    print(e)
  
  return conn

def create_table(conn):
  current_time = int(time.time()*1000)

  create_config_table_sql = """CREATE TABLE meta (
    id INTEGER PRIMARY KEY,
    label TEXT,
    value INTEGER
  );"""

  add_last_updated_sql = """INSERT INTO meta (id, label, value) VALUES (0, 'cloudLastCheckedDate', ?);"""

  create_message_table_sql = """CREATE TABLE messages (
    id INTEGER PRIMARY KEY,
    created INTEGER,
    date TEXT,
    language TEXT,
    location TEXT,
    speaker TEXT,
    speakerurl TEXT,
    taglist TEXT,
    title TEXT,
    url TEXT,
    durationinseconds REAL,
    lastplayedposition REAL,
    isdownloaded INTEGER,
    iscurrentlydownloading,
    filepath TEXT,
    isfavorite INTEGER,
    isplayed INTEGER
  );"""

  create_playlists_table_sql = """CREATE TABLE playlists (
    id INTEGER PRIMARY KEY,
    created INTEGER,
    title TEXT
  );"""

  insert_initial_playlist_sql = """INSERT INTO playlists (id, created, title) VALUES (0, ?, 'Saved for Later');"""

  create_playlist_message_junction_table_sql = """CREATE TABLE mpjunction (
    messageid INTEGER NOT NULL REFERENCES messages(id),
    playlistid INTEGER NOT NULL REFERENCES playlists(id),
    messagerank INTEGER,
    PRIMARY KEY(messageid, playlistid)
  );"""

  try:
    c = conn.cursor()
    c.execute(create_config_table_sql)
    c.execute(add_last_updated_sql, (current_time,))
    c.execute(create_message_table_sql)
    c.execute(create_playlists_table_sql)
    c.execute(insert_initial_playlist_sql, (current_time,))
    c.execute(create_playlist_message_junction_table_sql)
  except Error as e:
    print(e)

def insert_message(conn, message):
  taglist = ''
  if message['tags'] is not None and len(message['tags']) > 0:
    for tag in message['tags']:
      taglist += tag['display'] + ','

  if len(taglist) > 0:
    taglist = taglist[:-1]

  durationinseconds = None
  lastplayedposition = 0.0
  isdownloaded = 0
  filepath = ''
  isfavorite = 0
  isplayed = 0
  
  sql = """INSERT INTO messages(
    id,
    created,
    date,
    language,
    location,
    speaker,
    speakerurl,
    taglist,
    title,
    url,
    durationinseconds,
    lastplayedposition,
    isdownloaded,
    iscurrentlydownloading,
    filepath,
    isfavorite,
    isplayed
  ) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);"""

  c = conn.cursor()
  c.execute(sql, 
    (message['id'],
    int(time.time()*1000),
    message['date'],
    message['language'],
    message['location'],
    message['speaker'],
    message['speakerURL'],
    taglist,
    message['title'],
    message['url'],
    durationinseconds,
    lastplayedposition,
    isdownloaded,
    0,
    filepath,
    isfavorite,
    isplayed))

def get_cloud_data():
  url = 'https://us-central1-voices-for-christ.cloudfunctions.net/getMessagesSinceDate?time=0'
  res = requests.get(url)
  messages = res.json()
  return messages

def main():
  database = r'H:\Documents\Programming\voicesforchrist\initial-database\initial_message_database2.db'
  conn = create_connection(database)
  create_table(conn)

  with open('messages.json') as json_file:
    messages = json.load(json_file)

  with conn:
    #messages = get_cloud_data()
    for mid in messages:
      message = messages[mid]
      message['id'] = mid
      insert_message(conn, message)

    """for i in range(1,120000):
      message = {}
      message['id'] = i
      message['title'] = 'Message ' + str(i) + ' is about a topic to be discussed'
      message['created'] = randrange(100000000000)
      message['date'] = 1900
      message['language'] = 'English'
      message['location'] = 'here it is'
      message['speaker'] = 'Random speaker, who knows'
      message['speakerURL'] = 'https://voicesforchrist.net/welcome/search?q='
      message['tags'] = [{'display': 'Tag 1'}, {'display': 'Tag 2'}]
      message['url'] = 'https://voicesforchrist.net/welcome/search?q='
      insert_message(conn, message)"""

if __name__ == '__main__':
  main()
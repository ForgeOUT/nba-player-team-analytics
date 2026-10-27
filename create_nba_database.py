import pandas as pd
import sqlite3

nba_data = pd.read_csv("nba_players_regular_season_25_26_wide_data.csv")
print(nba_data.columns.tolist())

connection = sqlite3.connect("nba_analysis.db")

players = nba_data[["player_id", "player_name", "team", "position"]]

stats = nba_data[
    ["player_id", "minutes_played", "assists", "offensive_rebounds", "defensive_rebounds", "wins", "losses"]
]

players.to_sql("nba_players", connection, if_exists="replace", index=False)
stats.to_sql("player_stats", connection, if_exists="replace", index=False)

connection.close()

print("NBA database created successfully.")
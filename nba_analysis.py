import pandas as pd
import matplotlib.pyplot as plt

nba_data = pd.read_csv("nba_players_regular_season_25_26_wide_data.csv")

print(nba_data.head())
print(nba_data.columns)
print(nba_data.shape)
print(nba_data.info())
print(nba_data.describe())

top_assists = nba_data.sort_values("assists", ascending=False)
print(top_assists[["player_name", "team", "assists"]].head(10))

print(nba_data.isnull().sum())

position_assists = nba_data.groupby("position")["assists"].mean().sort_values(ascending=False)
print(position_assists)

nba_data["games_played"] = nba_data["wins"] + nba_data["losses"]
print(nba_data[["player_name", "wins", "losses", "games_played"]].head(10))

nba_data["assists_per_game"] = nba_data["assists"] / nba_data["games_played"]
print(nba_data[["player_name", "assists", "games_played", "assists_per_game"]].head(10))

top_apg = nba_data.sort_values("assists_per_game", ascending=False)
print(top_apg[["player_name", "team", "games_played", "assists_per_game"]].head(10))

position_apg = nba_data.groupby("position")["assists_per_game"].mean().sort_values(ascending=False)
position_apg.plot(kind="bar")
plt.title("Average Assists Per Game by Position")
plt.xlabel("Position")
plt.ylabel("Assists Per Game")
plt.show()

team_apg = nba_data.groupby("team")["assists_per_game"].mean().sort_values(ascending=False)
print(team_apg)

nba_data["rebounds_per_game"] = (nba_data["offensive_rebounds"] + nba_data["defensive_rebounds"]) / nba_data["games_played"]
position_stats = nba_data.groupby("position")[["rebounds_per_game", "assists_per_game"]].mean()

position_rpg = nba_data.groupby("position")["rebounds_per_game"].mean().sort_values(ascending=False)
position_rpg.plot(kind="bar")
plt.title("Average Rebounds Per Game by Position")
plt.xlabel("Position")
plt.ylabel("Rebounds Per Game")
plt.show()

duplicate_rows = nba_data.duplicated().sum()
print(duplicate_rows)

print(nba_data.dtypes)

top_rebounders = nba_data.sort_values("rebounds_per_game", ascending=False)
print(top_rebounders[["player_name", "team", "position", "rebounds_per_game"]].head(10))

top_assisters = nba_data[nba_data["games_played"] >= 50].sort_values("assists_per_game", ascending=False)
print(top_assisters[["player_name", "team", "games_played", "assists_per_game"]].head(10))

# Equihub marketplace for Claude

Equihub's plugins for Claude.

| Plugin | What it does |
|---|---|
| [Equihub](plugins/equihub) | Your stable's records in Claude. Check what is due, look up any horse and tick off the day's tasks. |

## Install in Claude Code

```
/plugin marketplace add Mos-Pelgo-Ventures/equihub-marketplace
/plugin install Equihub@Equihub
```


## Layout

```
.claude-plugin/marketplace.json   the marketplace and its plugin list
plugins/<plugin>/                 one folder per plugin
```

To add a plugin, create `plugins/<name>/` with its own `.claude-plugin/plugin.json`, then add an entry with `"source": "./plugins/<name>"` to `marketplace.json`.

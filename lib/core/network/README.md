# Core networking

Place shared transport clients, connectivity abstractions and network policy here only when the final application needs them. Feature-specific Firebase access belongs in the relevant feature's data repository.

Do not put widgets or business rules in this folder. The current starter uses Firebase SDK streams and does not yet require a separate HTTP client.
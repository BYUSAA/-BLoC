# Core services

Place cross-feature infrastructure services here when more than one feature needs them. Examples include secure device services or application-wide notification adapters.

Feature-owned data access should remain inside its feature data layer. Avoid service locators and global singletons without a clear lifecycle and test strategy.
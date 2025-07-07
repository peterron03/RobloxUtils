# RobloxUtils
A collection of utility functions for Roblox that I tend to use often.

## Dependencies
For the use of the `.getCountryEmojiFromCode` function, as well as potential future functions that may use unicodes, [Unicodes](https://github.com/peterron03/Unicodes) is required. Make sure it's a child of whatever script the `.getCountryEmojiFromCode` function is part of.

## Functions

| Function | Description |
| --- | --- |
| .isPrivateServer | Returns `true` if the current server is a private server or `false` otherwise |
| .createSignal | Creates a `RemoteEvent` given the provided `eventName`, parenting it to the provided `remotes` folder or ReplicatedStorage |
| .lerpColor | Works similarly to `Vector3:Lerp`, but for `Color3`, lerping the provided `color1` and `color2` based on the provided `alpha` |
| .playTempSoundClone | Clones the provided `Sound`, immediately plays it, then destroys it after either the provided `destroyAfter` or 5 seconds |
| .getHRPAndHumanoidFromPlayer | Returns the `HumanoidRootPart` and `Humanoid` of the provided `Player`, if they exist |
| .getRandomValuesFromArray | Returns a table which includes a random amount of values based on the `min` and `max`, with each value being randomly picked from the provided `array`, given the provided `increasedChanceForValue` |
| .playerOwnsBadge | Returns `true` if `player` owns `badgeId` or `false` if not |
| .awardBadge | Awards the provided `player` with a badge, based on the provided `badgeId`, using BadgeService |
| .isEffect | Returns true if parameter is either a `ParticleEmitter`, `Fire`, `Trail`, `Beam`, `Smoke`, or `Highlight` |
| .lerp | Simple lerp function; equivalent to `Vector3:Lerp()` |
| .quadraticBezier | Function for bezier curves, mainly used for object manipulation |
| .isMobile | Returns true if `Players.LocalPlayer` is on mobile, based on multiple factors |
| .commaValue | Adds commas to a number (ex. 1000 -> 1,000) |
| .roundNumber | Similar to `math.round()`, but with an optional `numberOfDecimalPlaces` parameter |
| .formatNumber | Formats numbers using letter abbreviation (ex. 1,294 -> 1.29K), all the way up to tredecillion, with optional parameters |
| .Format | Formats a string based on the `formatString` parameter; equivalent to `string.format()` |
| .convertToHMS | Converts the provided amount of seconds into hours, minutes, and seconds, with optional milliseconds |
| .getLastInput | Returns either `"touch"`, `"controller"`, or `"mouse"` depending on the last input of `Players.LocalPlayer` |
| .getCountryCode | Returns a 2 letter country code, equivalent to `LocalizationService:GetCountryRegionForPlayerAsync` |
| .getCountryEmojiFromCode | Based on a module of codes, returns unicode text for a flag emoji for the provided country code |
| .getPlayerFromString | Uses `string.find()` to find the player that matches the provided string the most |
| .canSendGameInvite | Returns true if player can send game invites; equivalent to `SocialService:CanSendGameInviteAsync(player)` |
| .isInGroupAsync | Similar to `player:IsInGroup()`, except it doesn't cache and uses `GroupService:GetGroupsAsync()` |

# RobloxUtils
A collection of utility functions for Roblox that I tend to use often.

## Functions

| Function | Description |
| --- | --- |
| .awardBadge | Awards the provided `player` with a badge, based on the provided `badgeId`, using BadgeService. |
| .isEffect | Returns true if parameter is either a `ParticleEmitter`, `Fire`, `Trail`, `Beam`, `Smoke`, or `Highlight` |
| .lerp | Simple lerp function, equivalent to `Vector3:Lerp()` |
| .quadraticBezier | Function for bezier curves, mainly used for object manipulation |
| .isMobile | Returns true if `Players.LocalPlayer` is on mobile, based on multiple factors |
| .commaValue | Adds commas to a number (ex. 1000 -> 1,000) |
| .roundNumber | Similar to `math.round()`, but with an optional `numberOfDecimalPlaces` parameter |
| .formatNumber | Formats numbers using letter abbreviation (ex. 1,294 -> 1.29K), all the way up to tredecillion, with optional parameters |
| .Format | Equivalent to `string.format()` |
| .convertToHMS | Converts the provided amount of seconds into hours, minutes, and seconds, with optional milliseconds |
| .getLastInput | Returns either `"touch"`, `"controller"`, or `"mouse"` depending on the last input of `Players.LocalPlayer` |

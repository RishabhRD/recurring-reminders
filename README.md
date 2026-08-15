# Recurring Reminders

A native Omarchy Quattro bar widget for small, repeatable habits: water, posture, medication, breaks, or anything else that benefits from a gentle nudge.

Click the water-drop icon to add a reminder, set its repeat interval, pause it, snooze it for ten minutes, or remove it. The reminder data is stored in `~/.local/state/omarchy/recurring-reminders.json` and is retained across shell restarts.

**NOTE:** This is an AI-generated plugin and thus can have bugs.

![Screenshot](https://private-user-images.githubusercontent.com/26287448/636477068-9def618c-4ffe-4747-aaa8-f5fd7cd6f7ea.png?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3ODY3NzUxMTIsIm5iZiI6MTc4Njc3NDgxMiwicGF0aCI6Ii8yNjI4NzQ0OC82MzY0NzcwNjgtOWRlZjYxOGMtNGZmZS00NzQ3LWFhYTgtZjVmZDdjZDZmN2VhLnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNjA4MTUlMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjYwODE1VDA2MjAxMlomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPWMxZWQzOGJiMDQ1ODRmMDVlYmVmMzEyZjk5YzMyNWY4ZTJmMWNiNTNiNzM2ZWU0OThmYjZhMjExYmRiYWRiYzQmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0JnJlc3BvbnNlLWNvbnRlbnQtdHlwZT1pbWFnZSUyRnBuZyJ9.jCme1aLBOJ-EApwrAbcRHPo1o5_nREKQfJmNQLqF4pw)

## Intervals

Intervals can be 1 minute through 7 days (10,080 minutes). The first notification is sent after the interval you choose; subsequent notifications repeat on that cadence.

## Install

```
omarchy plugin add https://github.com/RishabhRD/recurring-reminders --enable
```

## Uninstall

```
omarchy plugin remove recurring-reminders
```

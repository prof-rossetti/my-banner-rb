# MyBanner

Parses banner's faculty schedule page and generates google calendar events to answer the question, "when are my classes this semester?"

## Installation

Clone from source:

```sh
git clone git@github.com:prof-rossetti/my-banner-rb.git
cd my-banner-rb/
```

## Configuration

Run `cp .env.example .env`, then customize variables in the **.env** file to use your own Google Calendar credentials.

## Setup

```sh
bin/setup
```

## Usage

### Schedule on Google Calendar

1. Login to https://myaccess.georgetown.edu/, then navigate to: **Home > Faculty Services > Faculty Detail Schedule** to access your schedule of classes. Note: you might need to select a term along the way.

2. Once you have accessed your schedule, use your browser to save the HTML page in this repository as: **pages/faculty-detailed-schedule.html**.

3. Finally, execute the scheduling program:

```rb
ruby script/scheduler.rb
```

## [Contributing](/CONTRIBUTING.md)

## [License](/LICENSE.md)

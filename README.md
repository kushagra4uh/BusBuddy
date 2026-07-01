# BusBuddy

BusBuddy is a Django-based bus booking and route management web application. It was built as a college project to demonstrate a complete server-rendered web app with authentication, database models, route search, bus registration, bookings, and a simulated payment flow.

## Project Overview

The application has two main user flows:

- Passengers can register, log in, search for buses, check route details, select seats, and confirm bookings.
- Conductors can create an operator profile, register buses, add route stops, set schedules, and review bus availability from a dashboard.

The project uses Django templates and a custom responsive CSS layout, so it runs as a full-stack Python web application without needing a separate frontend framework.

## Live Demo

Render deployment:

```text
https://bus-buddy-project-ub04.onrender.com
```

Note: this free Render deployment uses SQLite inside the web service for demo purposes. For a production version, connect a PostgreSQL database through `DATABASE_URL`.

## Features

- User registration and login
- Passenger route search by source and destination
- Optional filters for date, operating day, AC type, seating type, and driver information
- Bus registration for conductors/operators
- Route creation with origin, destination, intermediate stops, and stop timings
- Weekly and date-based schedule support
- Seat availability calculation based on existing bookings
- Booking creation for logged-in users
- Simulated payment confirmation flow
- Passenger dashboard with booking history
- Conductor dashboard with registered buses and schedules
- Responsive UI for desktop and mobile screens
- Static file handling with WhiteNoise

## Tech Stack

- Python
- Django 5.2
- SQLite
- Django Templates
- HTML5
- CSS3
- JavaScript
- WhiteNoise
- Gunicorn

## Folder Structure

```text
BUS_BUDDY-main/
  busbuddy/
    manage.py
    db.sqlite3
    busbuddy/
      settings.py
      urls.py
      wsgi.py
    main/
      models.py
      views.py
      forms.py
      urls.py
      templates/main/
      static/main/
  requirements.txt
  Procfile
  RUN_LIVE.ps1
```

## Local Setup

Create and activate a virtual environment:

```powershell
python -m venv .venv
.\.venv\Scripts\activate
```

Install dependencies:

```powershell
pip install -r requirements.txt
```

Run migrations if needed:

```powershell
cd busbuddy
python manage.py migrate
```

Start the development server:

```powershell
python manage.py runserver
```

Open the app:

```text
http://127.0.0.1:8000/
```

## Public Demo Link From Local Machine

This repository includes `RUN_LIVE.ps1`, which starts the Django server and creates a temporary public Cloudflare Tunnel link.

From the project root, run:

```powershell
powershell -ExecutionPolicy Bypass -File .\RUN_LIVE.ps1
```

The script prints a public `trycloudflare.com` URL that can be shared for demos. Keep the computer awake while sharing the link.

## Production Deployment Notes

This is a Django backend application, so it is best deployed on a Python web host such as Render, Railway, Fly.io, or a VPS. Netlify is better suited for static frontends and serverless functions, not a traditional long-running Django WSGI app.

For step-by-step GitHub and Render deployment instructions, see [`DEPLOYMENT_GUIDE.md`](DEPLOYMENT_GUIDE.md).

Required production environment variables:

```text
DJANGO_DEBUG=False
DJANGO_SECRET_KEY=your-secure-secret-key
DJANGO_ALLOWED_HOSTS=your-domain.com
```

Build/start commands for a Python host:

```powershell
pip install -r requirements.txt
cd busbuddy
python manage.py collectstatic --noinput
gunicorn busbuddy.wsgi:application
```

## Demo Accounts

You can create accounts directly from the registration page.

Local demo account created during testing:

```text
Email: student@example.com
Password: Student@123
```

For conductor features:

1. Sign up as a user.
2. Go to "List a bus".
3. Complete conductor registration if prompted.
4. Add bus, route, stops, and schedule details.
5. Search for that route from the passenger search page.

## Future Enhancements

- Real payment gateway integration with Razorpay or Stripe
- PostgreSQL database for production
- Email confirmations for bookings
- Admin analytics dashboard
- Live GPS tracking integration
- Seat map selection instead of only seat count
- Booking cancellation and refund workflow

## Project Status

The project is ready for college submission and portfolio demonstration. It includes the core booking workflow, cleaned UI, readable documentation, and a temporary live-link script for easy demos.

## Viva / Interview Preparation

See [`INTERVIEW_QUESTIONS.md`](INTERVIEW_QUESTIONS.md) for likely teacher/interviewer questions, short answers, project terminology, and important topics to revise.

# Deployment Guide: GitHub + Render

## Can this project run only on GitHub?

No. GitHub can store the code, but GitHub Pages only hosts static files such as HTML, CSS, and JavaScript. BusBuddy is a Django backend project, so the backend will not run on GitHub Pages.

Recommended production setup:

```text
GitHub = code repository
Render = live Django backend hosting
PostgreSQL = production database
```

Current free demo setup:

```text
GitHub = code repository
Render = live Django backend hosting
SQLite = demo database inside the web service
```

The current Render free account could not create another free PostgreSQL database, so the deployed demo uses SQLite. This is acceptable for a college demo link, but PostgreSQL is recommended for real production use.

Official references:

- GitHub Pages is for static sites: https://docs.github.com/en/pages/getting-started-with-github-pages/what-is-github-pages
- Render supports Django deployment: https://render.com/docs/deploy-django

## Files Added for Deployment

- `render.yaml` - Render blueprint configuration for the web service
- `build.sh` - Render build script
- `runtime.txt` - Python version
- `.env.example` - sample environment variables
- `requirements.txt` - production dependencies
- `Procfile` - generic Python web start command

## Step 1: Push Project to GitHub

Open PowerShell in the project root:

```powershell
cd "C:\Users\lenovo\Downloads\BUS_BUDDY-main (2)\BUS_BUDDY-main"
```

Check files:

```powershell
git status
```

Add and commit:

```powershell
git add .
git commit -m "Prepare BusBuddy for deployment"
```

Create a new repository on GitHub:

1. Go to https://github.com/new
2. Repository name: `busbuddy`
3. Keep it public if you want to show it on your resume.
4. Do not initialize with README because this project already has one.
5. Click "Create repository".

Connect local project to GitHub:

```powershell
git remote add origin https://github.com/YOUR_USERNAME/busbuddy.git
git push -u origin main
```

Replace `YOUR_USERNAME` with your GitHub username.

## Step 2: Deploy on Render

1. Go to https://render.com
2. Sign in with GitHub.
3. Click "New +".
4. Choose "Blueprint".
5. Select your `busbuddy` GitHub repository.
6. Render will detect `render.yaml`.
7. Click "Apply".

Render will create:

- A Django web service
- Environment variables from `render.yaml`

## Step 3: Wait for Build

Render runs:

```bash
./build.sh
```

The script:

```bash
pip install -r requirements.txt
python busbuddy/manage.py collectstatic --noinput
python busbuddy/manage.py migrate
```

Then Render starts the app with:

```bash
cd busbuddy && gunicorn busbuddy.wsgi:application
```

## Step 4: Open the Live Link

After deployment, Render gives a URL like:

```text
https://busbuddy.onrender.com
```

The current deployed URL is:

```text
https://bus-buddy-project-ub04.onrender.com
```

That is the public link you can put in your resume.

## Will the Backend Work on Render?

Yes, the backend works on Render because:

- Render runs Python web apps.
- The project uses Gunicorn for production.
- Static files are served with WhiteNoise.
- SQLite is available for the current demo deployment.
- PostgreSQL can be configured later through `DATABASE_URL`.
- `ALLOWED_HOSTS` and `CSRF_TRUSTED_ORIGINS` support Render domains.

## Important Production Notes

- The local SQLite database is not uploaded.
- The current free deployment uses SQLite.
- You may need to create new demo data after redeploys because SQLite is not a managed production database.
- The first request may be slow on Render free plan because free services can sleep.
- If you change code, push to GitHub and Render will redeploy.

## After Deployment Demo Flow

1. Open the Render URL.
2. Register a user.
3. Log in.
4. Go to "List a bus".
5. Create a conductor profile.
6. Register a bus and route.
7. Search that route.
8. Book a seat.
9. Confirm simulated payment.
10. Show passenger dashboard.

## Common Errors

### CSRF verification failed

Check `DJANGO_CSRF_TRUSTED_ORIGINS`. It should include:

```text
https://*.onrender.com
```

### DisallowedHost error

Check `DJANGO_ALLOWED_HOSTS`. It should include:

```text
.onrender.com
```

### Static files not loading

Check that `collectstatic` ran during build and `whitenoise` is installed.

### Database tables missing

Check that `python busbuddy/manage.py migrate` ran during build.

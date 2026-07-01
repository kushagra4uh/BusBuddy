from datetime import time

from django.db import migrations


def seed_demo_route(apps, schema_editor):
    User = apps.get_model("auth", "User")
    Conductor = apps.get_model("main", "Conductor")
    Bus = apps.get_model("main", "Bus")
    Route = apps.get_model("main", "Route")
    Stop = apps.get_model("main", "Stop")
    Schedule = apps.get_model("main", "Schedule")

    user, _ = User.objects.get_or_create(
        username="demo.conductor@busbuddy.local",
        defaults={
            "email": "demo.conductor@busbuddy.local",
            "first_name": "Demo",
            "last_name": "Conductor",
        },
    )

    conductor, _ = Conductor.objects.get_or_create(
        user=user,
        defaults={
            "phone": "9999999999",
            "license_number": "DEMO-LIC-001",
        },
    )

    bus, _ = Bus.objects.get_or_create(
        registration_number="DEMO-UP32-BB-1010",
        defaults={
            "bus_name": "Campus Express",
            "fleet_number": "CE-01",
            "ac_type": "AC",
            "bus_type": "Seater",
            "is_sleeper": False,
            "total_seats": 42,
            "driver_name": "Ramesh Kumar",
            "conductor": conductor,
            "origin": "Meerut",
            "destination": "Kanpur",
            "stops": "Lucknow",
        },
    )

    route, _ = Route.objects.get_or_create(
        bus=bus,
        origin="Meerut",
        destination="Kanpur",
        defaults={"stops": "Lucknow"},
    )

    Stop.objects.get_or_create(
        route=route,
        name="Lucknow",
        defaults={"time": time(11, 30), "order": 1},
    )

    Schedule.objects.get_or_create(
        bus=bus,
        route=route,
        departure_time=time(8, 30),
        arrival_time=time(14, 10),
        defaults={"days": "Mon,Fri"},
    )


def unseed_demo_route(apps, schema_editor):
    Bus = apps.get_model("main", "Bus")
    User = apps.get_model("auth", "User")
    Bus.objects.filter(registration_number="DEMO-UP32-BB-1010").delete()
    User.objects.filter(username="demo.conductor@busbuddy.local").delete()


class Migration(migrations.Migration):

    dependencies = [
        ("main", "0012_schedule_date_alter_schedule_days"),
    ]

    operations = [
        migrations.RunPython(seed_demo_route, unseed_demo_route),
    ]

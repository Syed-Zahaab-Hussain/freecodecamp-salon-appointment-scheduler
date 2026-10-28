# Salon Appointment Scheduler

Bash and PostgreSQL project for the freeCodeCamp Relational Databases course. The program lists salon services, finds or creates a customer by phone number, and saves their appointment.

## Run

In the freeCodeCamp PostgreSQL environment:

```bash
psql -U postgres < salon.sql
chmod +x salon.sh
./salon.sh
```

The database dump recreates the `salon` database and expects the `freecodecamp` PostgreSQL role. On another system, create that role or adjust the connection in `salon.sh`.

Passed all 21 official CodeRoad project tests.

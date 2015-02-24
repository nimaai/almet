class AddExistsReservationsConstraintForVisitor < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do

        execute %(
          CREATE OR REPLACE FUNCTION check_existence_of_reservations()
          RETURNS TRIGGER AS $$
          BEGIN
            IF NOT EXISTS (
              SELECT *
              FROM reservations
              WHERE visitor_id = NEW.id )
            THEN
              RAISE EXCEPTION 'Visitor must have some reservations';
            END IF;

            RETURN NEW;
          END;
          $$ language 'plpgsql';
        )

        execute %(
          CREATE CONSTRAINT TRIGGER trigger_existence_of_reservations
          AFTER INSERT OR UPDATE
          ON visitors
          INITIALLY DEFERRED
          FOR EACH ROW
          EXECUTE PROCEDURE check_existence_of_reservations()
        )

      end

      dir.down do
        execute %( DROP TRIGGER trigger_existence_of_reservations ON visitors )
        execute %( DROP FUNCTION IF EXISTS check_existence_of_reservations() )
      end
    end
  end
end

require_relative 'event_logger'


module Preservation
  class Demo
    def self.clean_slate!
      delete_all_file_sets!
      delete_all_preservation_events!
      delete_all_hydra_access_controls!
    end

    def self.delete_all_file_sets!
      FileSet.all.each { |fs| fs.delete }
    end

    def self.delete_all_preservation_events!
      Preservation::Event.all.each { |pe| pe.delete }
    end

    def self.delete_all_hydra_access_controls!
      ::Hydra::AccessControl.all.each { |ac| ac.delete }
    end

    def self.new_file_set
      FileSet.new.tap do |fs|
        fs.apply_depositor_metadata(User.first)
        fs.save!
      end
    end

    def self.run_once!
      file_set = new_file_set

      # NOTE: PreservationEventLogger is a stateless service object that provides a "use anywhere" interface
      # for logging preservation events. We don't have to use this pattern, but it has it's advantages.

      # Create two sets of people for some realistic randomness in the demo records.
      preservation_people = ['jlhardes@iu.edu', 'heidowdi@indiana.edu']
      ingest_people = ['akhedkar@iu.edu', 'afredmyers@gmail.com']


      # Create a fake capture date of sometime between now and 90 days ago.
      capture_date = DateTime.now - rand(2..90).days
      # Create a fake fixity check date sometime between the capture date and now.
      fixity_date = rand(capture_date..DateTime.now)
      # Create a fake ingest date of sometime beetween the capture date and now.
      ingest_date = rand(capture_date..DateTime.now)

      # Create an event for the file's capture.
      Preservation::EventLogger.log_preservation_event(
        file_set: file_set,
        premis_event_type: 'cap',
        premis_agent: preservation_people.sample,
        premis_event_date_time: capture_date
      )

      # Create an event for the file's fixity check.
      Preservation::EventLogger.log_preservation_event(
        file_set: file_set,
        premis_event_type: 'fix',
        premis_agent: preservation_people.sample,
        premis_event_date_time: fixity_date
      )

      # Create an event for the file's ingestion.
      Preservation::EventLogger.log_preservation_event(
        file_set: file_set,
        premis_event_type: 'ing',
        premis_agent: ingest_people.sample,
        premis_event_date_time: ingest_date
      )
    end

    def self.run!(iterations=1)
      iterations.times { self.run_once! }
    end
  end
end
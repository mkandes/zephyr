/* DATABASE INITIALIZATION : zephyr.db :: sqlite3                     */

INSERT INTO provider ( provider_name )
     VALUES ( 'amazon' );

INSERT INTO region ( region_provider_id, region_name )
     SELECT provider.provider_id, 'us-east-1'
       FROM provider
      WHERE provider.provider_name = 'amazon';

INSERT INTO zone ( zone_region_id, zone_name )
     SELECT region.region_id, 'us-east-1a'
       FROM region
      WHERE region.region_name = 'us-east-1';

INSERT INTO zone ( zone_region_id, zone_name )
     SELECT region.region_id, 'us-east-1b'
       FROM region
      WHERE region.region_name = 'us-east-1';

INSERT INTO zone ( zone_region_id, zone_name )
     SELECT region.region_id, 'us-east-1c'
       FROM region
      WHERE region.region_name = 'us-east-1';

INSERT INTO zone ( zone_region_id, zone_name )
     SELECT region.region_id, 'us-east-1d'
       FROM region
      WHERE region.region_name = 'us-east-1';

INSERT INTO region ( region_provider_id, region_name )
     SELECT provider.provider_id, 'us-west-2'
       FROM provider
      WHERE provider.provider_name = 'amazon';

INSERT INTO zone ( zone_region_id, zone_name )
     SELECT region.region_id, 'us-west-2a'
       FROM region
      WHERE region.region_name = 'us-west-2';

INSERT INTO zone ( zone_region_id, zone_name )
     SELECT region.region_id, 'us-west-2b'
       FROM region
      WHERE region.region_name = 'us-west-2';

INSERT INTO zone ( zone_region_id, zone_name )
     SELECT region.region_id, 'us-west-2c'
       FROM region
      WHERE region.region_name = 'us-west-2';

INSERT INTO provider ( provider_name )
     VALUES ( 'google' );

INSERT INTO provider ( provider_name )
     VALUES ( 'microsoft' );

INSERT INTO user ( user_username, user_email )
     VALUES ( 'zephyr', 'zephyr@sdsc.edu' );

/* END DATABASE INITIALIZATION : zephyr.db :: sqlite3                 */

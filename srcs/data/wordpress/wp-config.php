<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the web site, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * Localized language
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** Database username */
define( 'DB_USER', 'wpuser' );

/** Database password */
define( 'DB_PASSWORD', 'wppass' );

/** Database hostname */
define( 'DB_HOST', 'mariadb' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',          '#<-9#RvMQr@Zq3tu6Yq2H/r&p4:k!9,Ue3iMG|JX:_a5~9vlS%jd>mPcw!yieAM-' );
define( 'SECURE_AUTH_KEY',   'eH[T?!@!XLI_o{(wf@@+#:~qse1lZM;BmT`ZqJp;?w7,<2|(2T^9Q>d2HCmkZ#[>' );
define( 'LOGGED_IN_KEY',     '*L&0ym#<e3rNkgBJbrY;<kS%:@]?01=tQ)+~>l`9u!W5knU5?NnOCuROISa`,~3P' );
define( 'NONCE_KEY',         'xag88p{oxx=Nv)N4%!f57K^j:8S7I#$.If 2*|D^@?:#|h%x(+}7EHKp|omUFY#9' );
define( 'AUTH_SALT',         'Lz%*( A:jqaMY/DZ7lsL&A.A! ??c`1V#TbrzMeyS-SM6&b&WY/)wz<.Rm(l,a(P' );
define( 'SECURE_AUTH_SALT',  'S!# A~~aDA<4kS5,YO]xHV0WRaM6h(?!hUg1,9dM]P(aK-jUGGfs]q~q(Wa`@O60' );
define( 'LOGGED_IN_SALT',    'xKW>HBLBA>K%=0q<OOr*#I-v5TbL+Ji]{D&OoNpSOC5mQy9=[RU4:oxYZ{z#YrA`' );
define( 'NONCE_SALT',        '*u(vRO;u?W @aq h^</,9Ht4P]z17^NcBl!8kcUL)bFg!E9.ePQ&`duWe52`)<C0' );
define( 'WP_CACHE_KEY_SALT', 'lg8Ea&NlP?B~p=>.&NQ 6FonORG>5(l>k<RiG)}pX+U[Dg`>Hl{`Q&^i!T*qV*mu' );


/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';


/* Add any custom values between this line and the "stop editing" line. */



/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
if ( ! defined( 'WP_DEBUG' ) ) {
	define( 'WP_DEBUG', false );
}

define( 'FORCE_SSL_ADMIN', false );
/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';

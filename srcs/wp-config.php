<?php
/**
 * Custom WordPress configurations on "wp-config.php" file.
 *
 * This file has the following configurations: MySQL settings, Table Prefix, Secret Keys, WordPress Language, ABSPATH and more.
 * For more information visit {@link https://codex.wordpress.org/Editing_wp-config.php Editing wp-config.php} Codex page.
 * Created using {@link http://generatewp.com/wp-config/ wp-config.php File Generator} on GenerateWP.com.
 *
 * @package WordPress
 * @generator GenerateWP.com
 */


/* MySQL settings */
define( 'DB_NAME',     'wordpress' );
define( 'DB_USER',     'wordpress' );
define( 'DB_PASSWORD', 'password' );
define( 'DB_HOST',     'localhost' );
define( 'DB_CHARSET',  'utf8mb4' );


/* MySQL database table prefix. */
$table_prefix = 'wp_';


/* Authentication Unique Keys and Salts. */
/* https://api.wordpress.org/secret-key/1.1/salt/ */
define('AUTH_KEY',         '{*m}?e)cn:y:SO8`Ss:~,5)YOE)>2EXR^9]Dna?i%Lj3j+|g4|$Kj}4g+!%n|u*b');
define('SECURE_AUTH_KEY',  '!ghqb{6CBn:XJ9)!dCF|B 8|GOht]p|DOileC/-C,-4abRo:#^=tP6vqAFJg%9 y');
define('LOGGED_IN_KEY',    '(K|T].pm[XU3-+nQ+NbkDY-BL%QJo~.n!6RsjqJN-ti<Y<NfP=V*_4TqFl}59|hv');
define('NONCE_KEY',        '.fG0:}jx,~nHXu6w6ah9/p-y2N})n-}-|5Q#bbq2w6Pe?.vBFZ#l<Kj/D,{$%+!t');
define('AUTH_SALT',        'ut(iMD=b3i/H-VR*w8jf8xSsqD9xO_3Iuvv[po2YHTND_bvz&NmcMsE;G-F0]Y=V');
define('SECURE_AUTH_SALT', '^Wa6RNy2^2;cK~43[Zh$D W<^otQWNNhVOPVKP83pj+Wez).a o688lJp:,]/m|F');
define('LOGGED_IN_SALT',   ' A7%M]N]u}14AH>M4dY.}Gno$4^2u||Yavj&7i+;YL_25[6]y/tN6Z1e#o>(^dAt');
define('NONCE_SALT',       'aAqp|W#_i(:r$e;}Yx{7k-1a2`08>NL*P2ZI&V@+}5{`$Zws]x)w1Ml0mJg9W@[#');


/* Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/* Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
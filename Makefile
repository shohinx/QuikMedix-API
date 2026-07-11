.PHONY: recover-laravel composer-lock prepare-storage

# Recreates the Laravel files that were omitted from the downloaded project.
# This will not overwrite existing files.
recover-laravel:
	@test ! -e artisan || { echo "artisan already exists; refusing to overwrite it."; exit 1; }
	@test ! -e composer.json || { echo "composer.json already exists; refusing to overwrite it."; exit 1; }
	@printf '%s\n' '#!/usr/bin/env php' '<?php' '' 'define('\''LARAVEL_START'\'', microtime(true));' '' 'require __DIR__. '\''/vendor/autoload.php'\'';' '' '$$app = require_once __DIR__. '\''/bootstrap/app.php'\'';' '$$kernel = $$app->make(Illuminate\Contracts\Console\Kernel::class);' '' '$$status = $$kernel->handle(' '    $$input = new Symfony\Component\Console\Input\ArgvInput,' '    new Symfony\Component\Console\Output\ConsoleOutput' ');' '' '$$kernel->terminate($$input, $$status);' '' 'exit($$status);' > artisan
	@chmod +x artisan
	@printf '%s\n' '{' '  "name": "quikmedix/quikmedix-api",' '  "type": "project",' '  "description": "QuikMedix API",' '  "require": {' '    "php": "^8.0",' '    "authorizenet/authorizenet": "2.0.4",' '    "aws/aws-sdk-php": "3.388.4",' '    "barryvdh/laravel-dompdf": "1.0.2",' '    "defuse/php-encryption": "2.4.0",' '    "fideloper/proxy": "4.4.2",' '    "firebase/php-jwt": "6.11.1",' '    "fruitcake/laravel-cors": "2.2.0",' '    "intervention/image": "2.7.2",' '    "laravel/framework": "8.83.29",' '    "laravel/passport": "10.4.2",' '    "laravel/ui": "3.4.6",' '    "league/flysystem-aws-s3-v3": "1.0.30",' '    "milon/barcode": "8.0.1",' '    "munafio/chatify": "1.6.3",' '    "pusher/pusher-push-notifications": "2.0",' '    "smalot/pdfparser": "0.18.2",' '    "stripe/stripe-php": "7.128.0",' '    "twilio/sdk": "6.44.4",' '    "zadarma/user-api-v1": "1.1.9"' '  },' '  "autoload": {' '    "psr-4": {' '      "App\\": "app/",' '      "Database\\Factories\\": "database/factories/",' '      "Database\\Seeders\\": "database/seeders/"' '    }' '  },' '  "scripts": {' '    "post-autoload-dump": [' '      "Illuminate\\Foundation\\ComposerScripts::postAutoloadDump",' '      "@php artisan package:discover --ansi"' '    ]' '  },' '  "config": {' '    "optimize-autoloader": true,' '    "sort-packages": true,' '    "audit": {' '      "block-insecure": false' '    }' '  },' '  "minimum-stability": "stable",' '  "prefer-stable": true' '}' > composer.json
	@echo "Created artisan and composer.json. Run 'make composer-lock' next."

# Resolves dependencies and creates composer.lock. Run this with PHP 8.2+.
composer-lock:
	@composer validate --no-check-publish
	@composer update --no-dev --prefer-dist --no-interaction --optimize-autoloader

# Recreates directories Laravel needs at runtime (including in production images).
prepare-storage:
	@mkdir -p storage/framework/cache/data storage/framework/sessions storage/framework/views storage/logs
	@chmod -R ug+rwx storage bootstrap/cache

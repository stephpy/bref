<?php declare(strict_types=1);

namespace Bref\FunctionRuntime;

use Bref\Bref;
use Bref\Runtime\LambdaRuntime;
use Throwable;

class Main
{
    public static function run(): void
    {
        $lambdaRuntime = LambdaRuntime::fromEnvironmentVariable('function');

        $container = Bref::getContainer();

        try {
            $handler = $container->get(getenv('_HANDLER'));
        } catch (Throwable $e) {
            $lambdaRuntime->failInitialization($e->getMessage());
            exit(1);
        }

        $loopMax = getenv('BREF_LOOP_MAX') ?: 1;
        $loops = 0;
        while (true) {
            if (++$loops > $loopMax) {
                exit(0);
            }
            $success = $lambdaRuntime->processNextEvent($handler);
            // In case the execution failed, we force starting a new process regardless of BREF_LOOP_MAX
            // Why: an exception could have left the application in a non-clean state, this is preventive
            if (! $success) {
                exit(0);
            }
        }
    }
}
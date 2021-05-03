# Sharing Data Between Callbacks

One of the core Dash principles explained in the Getting Started Guide on Callbacks is that **Dash callbacks must never modify variables outside of their scope**. It is not safe to modify any global variables. This chapter explains why and provides some alternative patterns for sharing state between callbacks.

## Why Share State?

In some apps, you may have multiple callbacks that depend on expensive data processing tasks like making SQL queries, running simulations, or downloading data.

Rather than have each callback run the same expensive task, you can have one callback run the task and then share the results with the rest of the callbacks.

This need has been somewhat ameliorated now that you can have multiple outputs for one callback. This way, that expensive task can be done once and immediately used in all the outputs. But in some cases this still isn't ideal, for example if there are simple follow-on tasks that modify the results, like unit conversions. We shouldn't need to repeat a large database query just to change the results from Fahrenheit to Celsius!

## Why Global Variables Will Break Your app

Dash is designed to work in multi-user environments where multiple people may view the application at the same time and will have **independent sessions**.

If your app uses `global` variables, then one's user's session could set the variable to one value which would affect the next user's session.

Dash is also designed to be able to run with **multiple workers** so that callbacks can be executed in parallel.

When Dash apps run across multiple workers, their memory is *not shared*. This means that if you modify a global variable in one callback, that modification will not be applied to the rest of the workers.


## How to Share Data between Callbacks Safely
In order to share data safely across multiple Julia processes, we need to store the data somewhere that is accessible to each of the processes.

There are two main places to store this data:

  1. In the user's browser session.
  2. On the disk (e.g. on a file or on a new database).

These approaches are illustrated in the files `browser_session_share.jl` and `on_disk_share.jl` respectively.

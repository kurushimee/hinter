extends Node

signal transition_requested(call_after: Callable)
signal transitioned

signal dialogue_requested(text: String)

signal task_completed

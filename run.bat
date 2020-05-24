@echo off

tasm /zi base

if errorlevel 1 goto sof

tlink /v base

if errorlevel 1 goto sof

base

:sof
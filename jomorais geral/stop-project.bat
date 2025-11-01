@echo off
echo ============================================
echo      PARANDO PROJETO JOMORAIS
echo ============================================
echo.

REM Definir cores para o terminal
color 0C

echo [INFO] Parando servidores Node.js...

REM Matar todos os processos do Node.js que estão rodando na porta 3000 e 8000
echo [FRONTEND] Parando servidor frontend (porta 3000)...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":3000"') do (
    echo Matando processo %%a
    taskkill /F /PID %%a >nul 2>nul
)

echo [BACKEND] Parando servidor backend (porta 8000)...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":8000"') do (
    echo Matando processo %%a
    taskkill /F /PID %%a >nul 2>nul
)

REM Matar processos do Node.js de forma mais ampla (cuidado!)
echo [INFO] Parando outros processos Node.js relacionados...
taskkill /F /IM node.exe >nul 2>nul
taskkill /F /IM nodemon.exe >nul 2>nul

echo.
echo ============================================
echo     SERVIDORES PARADOS COM SUCESSO!
echo ============================================
echo.
echo Todos os processos do projeto foram finalizados.
echo.
pause
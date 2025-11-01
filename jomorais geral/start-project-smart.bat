@echo off
setlocal enabledelayedexpansion

echo ============================================
echo    INICIO INTELIGENTE - PROJETO JOMORAIS
echo ============================================
echo.

REM Definir cores para o terminal
color 0B

REM Função para verificar se uma porta está em uso
:check_port
set "port=%1"
netstat -an | findstr ":%port%" >nul
if %errorlevel% equ 0 (
    set "port_in_use=true"
) else (
    set "port_in_use=false"
)
goto :eof

REM Verificar se o Node.js está instalado
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo ERRO: Node.js nao encontrado. Por favor, instale o Node.js primeiro.
    pause
    exit /b 1
)

echo [INFO] Verificando status das portas...

REM Verificar porta 8000 (Backend)
call :check_port 8000
if "!port_in_use!"=="true" (
    echo [WARNING] Porta 8000 ja esta em uso. Deseja parar o processo existente? (S/N)
    set /p "choice=Escolha: "
    if /i "!choice!"=="S" (
        echo [INFO] Parando processo na porta 8000...
        for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":8000"') do (
            taskkill /F /PID %%a >nul 2>nul
        )
        timeout /t 2 /nobreak >nul
    ) else (
        echo [INFO] Mantendo processo existente na porta 8000...
        set "skip_backend=true"
    )
) else (
    echo [OK] Porta 8000 disponivel para o backend.
    set "skip_backend=false"
)

REM Verificar porta 3000 (Frontend)
call :check_port 3000
if "!port_in_use!"=="true" (
    echo [WARNING] Porta 3000 ja esta em uso. Deseja parar o processo existente? (S/N)
    set /p "choice=Escolha: "
    if /i "!choice!"=="S" (
        echo [INFO] Parando processo na porta 3000...
        for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":3000"') do (
            taskkill /F /PID %%a >nul 2>nul
        )
        timeout /t 2 /nobreak >nul
    ) else (
        echo [INFO] Mantendo processo existente na porta 3000...
        set "skip_frontend=true"
    )
) else (
    echo [OK] Porta 3000 disponivel para o frontend.
    set "skip_frontend=false"
)

echo.
echo [INFO] Verificando dependencias...

REM Verificar e instalar dependências do backend
cd /d "%~dp0jomorais-backend"
if not exist "node_modules" (
    echo [BACKEND] Instalando dependencias do backend...
    call npm install
    if %errorlevel% neq 0 (
        echo ERRO: Falha ao instalar dependencias do backend.
        pause
        exit /b 1
    )
) else (
    echo [BACKEND] Dependencias do backend ja instaladas.
)

REM Verificar e instalar dependências do frontend
cd /d "%~dp0jomorais-fronend"
if not exist "node_modules" (
    echo [FRONTEND] Instalando dependencias do frontend...
    call npm install
    if %errorlevel% neq 0 (
        echo ERRO: Falha ao instalar dependencias do frontend.
        pause
        exit /b 1
    )
) else (
    echo [FRONTEND] Dependencias do frontend ja instaladas.
)

echo.
echo [INFO] Iniciando servidores...

REM Iniciar backend se necessário
if "!skip_backend!"=="false" (
    echo [BACKEND] Iniciando servidor backend...
    start "Backend - Jomorais" cmd /k "cd /d %~dp0jomorais-backend && npm run dev"
    timeout /t 3 /nobreak >nul
) else (
    echo [BACKEND] Servidor backend ja esta rodando.
)

REM Iniciar frontend se necessário
if "!skip_frontend!"=="false" (
    echo [FRONTEND] Iniciando servidor frontend...
    start "Frontend - Jomorais" cmd /k "cd /d %~dp0jomorais-fronend && npm run dev"
    timeout /t 8 /nobreak >nul
) else (
    echo [FRONTEND] Servidor frontend ja esta rodando.
)

REM Verificar se os serviços estão rodando
echo [INFO] Verificando status dos servidores...

call :check_port 8000
if "!port_in_use!"=="true" (
    echo [OK] Backend rodando na porta 8000
) else (
    echo [ERROR] Backend nao esta rodando na porta 8000
)

call :check_port 3000
if "!port_in_use!"=="true" (
    echo [OK] Frontend rodando na porta 3000
) else (
    echo [ERROR] Frontend nao esta rodando na porta 3000
)

REM Abrir o navegador
echo.
echo [INFO] Abrindo navegador...
start http://localhost:3000

echo.
echo ============================================
echo     PROJETO JOMORAIS INICIADO!
echo ============================================
echo.
echo Backend: http://localhost:8000
echo Frontend: http://localhost:3000
echo.
echo Para parar, use stop-project.bat ou Ctrl+C nas janelas abertas.
echo.
pause

@echo off
echo ============================================
echo      INICIANDO PROJETO JOMORAIS
echo ============================================
echo.

REM Definir cores para o terminal
color 0A

REM Verificar se o Node.js está instalado
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo ERRO: Node.js nao encontrado. Por favor, instale o Node.js primeiro.
    pause
    exit /b 1
)

REM Verificar se o npm está instalado
where npm >nul 2>nul
if %errorlevel% neq 0 (
    echo ERRO: npm nao encontrado. Por favor, instale o npm primeiro.
    pause
    exit /b 1
)

echo [INFO] Verificando dependencias...
echo.

REM Navegar para o diretório do backend e instalar dependências se necessário
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

REM Navegar para o diretório do frontend e instalar dependências se necessário
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
echo.

REM Iniciar o backend em uma nova janela
echo [BACKEND] Iniciando servidor backend na porta 8000...
start "Backend - Jomorais" cmd /k "cd /d %~dp0jomorais-backend && npm run dev"

REM Aguardar um pouco para o backend inicializar
timeout /t 3 /nobreak >nul

REM Iniciar o frontend em uma nova janela
echo [FRONTEND] Iniciando servidor frontend na porta 3000...
start "Frontend - Jomorais" cmd /k "cd /d %~dp0jomorais-fronend && npm run dev"

REM Aguardar o frontend inicializar
echo [INFO] Aguardando servidores iniciarem...
timeout /t 8 /nobreak >nul

REM Abrir o navegador
echo [INFO] Abrindo navegador...
start http://localhost:3000

echo.
echo ============================================
echo     PROJETO JOMORAIS INICIADO COM SUCESSO!
echo ============================================
echo.
echo Backend rodando em: http://localhost:8000
echo Frontend rodando em: http://localhost:3000
echo.
echo Para parar os servidores, feche as janelas abertas
echo ou use Ctrl+C em cada terminal.
echo.
pause
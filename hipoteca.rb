require 'pry'
require 'pry-nav'
require 'yaml'

MESSAGES = YAML.load_file('hipoteca_prompts.yml')

def messages(message, lang='sp')
  MESSAGES[lang][message]
end

def prompt(message)
  Kernel.puts("#{message}")
  puts
end

def number?(args)
  integer?(args) || float?(args)
end

def integer?(args)
  args.to_i.to_s == args
end

def float?(args)
  args.to_f.to_s == args
end

puts "
***********************************************************
      Bienvenido a la calculadora de hipotecas App!
  Proporcione los detalles de su esperado préstamo bancario
              Calcularemos el resto...
*********************************************************** "

name = ''

loop do
  prompt(messages('buyer_name', 'sp'))
  name = Kernel.gets().chomp().capitalize
  if name.empty?()
    prompt(messages('no_name', 'sp'))
  else
    break
  end
end

loop do
  puts "\n#{name},\n"
  
  loan = ''
  loop do
    prompt(messages('loan_amount', 'sp'))
    loan = Kernel.gets().chomp()

    if number?(loan)
      break
    else 
      prompt(messages('loan_format', 'sp'))
    end
  end

  years = ''
  loop do
    prompt(messages('years_mortgage', 'sp'))
    years = Kernel.gets().chomp()

    if integer?(years)
      break
    else 
      prompt(messages('years_format', 'sp'))
    end
  end

  apr = ''
  loop do
    prompt(messages('apr_mortgage', 'sp'))
    apr = Kernel.gets().chomp()

    if number?(apr)
      break
    else 
      prompt(messages('apr_format', 'sp'))
    end
  end

  puts
  prompt(messages('processing', 'sp'))
  years_int = years.to_i
  loan_int = loan.to_i
  apr_float = apr.to_f

  months = years_int * 12  
  mpr = (apr_float/100)/12.0  
  top_pay =  (((1 + mpr).round(9))**months).round(9)
  top_pay2 = (mpr * top_pay).round(10) 
  top_payment = loan_int * top_pay2
  btm_payment = (top_pay - 1).round(9)
  monthly_payment = (top_payment/btm_payment).round(2)
  total_payment = monthly_payment * months
  one_year = monthly_payment * 12
  remaining  = total_payment - one_year
  sleep 1

  puts "\nAquí está su calendario de pagos en un #{years} año $#{loan}.00 préstamo con #{apr}% APR:\n"
  puts "\nLa tasa de interés mensual: #{(mpr*100).round(2)}%\n"
  puts "\nLa duración total del préstamo: #{months} meses\n"
  puts "\nTu pago mensual fijo: $#{monthly_payment}\n"
  puts "\nDespués de 1 año, habría pagado: $#{one_year.round(2)} y habría $#{remaining.round(2)} pendientes de reembolso.\n"

  puts
  prompt(messages('new_calculation', 'sp'))
  continue = Kernel.gets().chomp()
  break unless continue.downcase().start_with?('y')
end

prompt(messages('bye', 'sp'))

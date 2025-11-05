class CreatePolicies < ActiveRecord::Migration[7.2]
  def change
    create_table :policies do |t|
      # Relación con policy_type
      t.references :policy_type, null: false, foreign_key: true

      # Detalles básicos
      t.string :name, null: false
      t.text :description

      # Derecho a prestación
      t.string :entitlement_type, null: false, default: 'basic_annual'
      t.decimal :annual_entitlement, precision: 10, scale: 2, default: 0.0

      # Periodo de actividad
      t.string :period_type, null: false, default: 'jan_dec'

      # Acumulación
      t.string :accrual_frequency, null: false, default: 'annual'
      t.string :accrual_timing, null: false, default: 'start_of_cycle'

      # Visualización
      t.string :balance_precision, null: false, default: 'decimals'

      # Prorrateo
      t.string :proration_calculation, null: false, default: 'working_days'
      t.boolean :grant_on_hire, default: false, null: false
      t.boolean :grant_on_termination, default: false, null: false

      # Límites de saldo - Remanente (Carryover)
      t.boolean :enable_carryover, default: false, null: false
      t.integer :carryover_limit, default: 0
      t.boolean :carryover_expires, default: false, null: false
      t.integer :carryover_expiration_amount, default: 1
      t.string :carryover_expiration_unit, default: 'months'

      # Límites de saldo - Máximo
      t.boolean :enable_max_balance, default: false, null: false
      t.integer :max_balance, default: 0

      # Límites de saldo - Mínimo
      t.boolean :enable_min_balance, default: false, null: false
      t.integer :min_balance, default: 0

      # Solicitudes de empleados
      t.decimal :min_advance_days, precision: 10, scale: 2, default: 1.0
      t.boolean :allow_retroactive, default: true, null: false
      t.boolean :allow_half_day, default: false, null: false
      t.decimal :min_request_period, precision: 10, scale: 2, default: 1.0
      t.decimal :max_request_period, precision: 10, scale: 2, default: 1.0

      # Bloqueo de nuevas contrataciones
      t.boolean :block_new_hire_requests, default: false, null: false
      t.integer :new_hire_block_days, default: 1
      t.string :new_hire_block_unit, default: 'days'

      # Bloqueo general de empleados
      t.boolean :block_employee_requests, default: false, null: false

      # Archivo adjunto
      t.string :attachment_requirement, default: 'optional'

      # Instrucciones
      t.text :instructions

      # Estado
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :policies, :name
    add_index :policies, :active
    add_index :policies, :entitlement_type
    add_index :policies, :period_type
  end
end

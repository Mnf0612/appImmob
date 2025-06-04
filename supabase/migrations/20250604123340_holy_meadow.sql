/*
  # Création des tables pour l'application immobilière

  1. Nouvelles Tables
    - `properties`
      - `id` (uuid, clé primaire)
      - `title` (text)
      - `description` (text)
      - `price` (numeric)
      - `surface` (numeric)
      - `bedrooms` (integer)
      - `bathrooms` (integer)
      - `images` (text[])
      - `created_at` (timestamp)
      - `agent_id` (uuid, clé étrangère)
      - `featured` (boolean)
    - `agents`
      - `id` (uuid, clé primaire)
      - `user_id` (uuid, clé étrangère)
      - `company_name` (text)
      - `subscription_status` (text)
      - `subscription_end_date` (timestamp)

  2. Sécurité
    - RLS activé sur les deux tables
    - Politiques de lecture publique pour les propriétés
    - Politiques d'écriture restreintes aux agents authentifiés
*/

-- Création de la table des agents
CREATE TABLE agents (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users NOT NULL,
  company_name text NOT NULL,
  subscription_status text NOT NULL DEFAULT 'inactive',
  subscription_end_date timestamptz,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE agents ENABLE ROW LEVEL SECURITY;

-- Création de la table des propriétés
CREATE TABLE properties (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  description text,
  price numeric NOT NULL,
  surface numeric NOT NULL,
  bedrooms integer NOT NULL,
  bathrooms integer NOT NULL,
  images text[] NOT NULL DEFAULT '{}',
  created_at timestamptz DEFAULT now(),
  agent_id uuid REFERENCES agents NOT NULL,
  featured boolean DEFAULT false
);

ALTER TABLE properties ENABLE ROW LEVEL SECURITY;

-- Politiques RLS
CREATE POLICY "Les propriétés sont visibles par tous"
  ON properties
  FOR SELECT
  USING (true);

CREATE POLICY "Seuls les agents peuvent créer des propriétés"
  ON properties
  FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM agents
      WHERE agents.user_id = auth.uid()
      AND agents.subscription_status = 'active'
    )
  );

CREATE POLICY "Les agents peuvent modifier leurs propres propriétés"
  ON properties
  FOR UPDATE
  TO authenticated
  USING (
    agent_id IN (
      SELECT id FROM agents
      WHERE agents.user_id = auth.uid()
    )
  );